function gatherClasses() {
    $page = Invoke-WebRequest -TimeoutSec 2 http://localhost/Courses.html

    # Get all tr elements
    $trs = $page.ParsedHtml.body.getElementsByTagName("tr")

    # Empty array
    $FullTable = @()
    for ($i = 1; $i -lt $trs.length; $i++) {  

        # Get every td element
        $tds = $trs[$i].getElementsByTagName("td")

        # Separate start time and end time
        $Times = $tds[5].innerText.Split("-")

        # Create custom object
        $FullTable += [PSCustomObject]@{
            "Class Code" = $tds[0].innerText;
            "Title"      = $tds[1].innerText;
            "Days"       = $tds[4].innerText;
            "Time Start" = $Times[0]
            "Time End"   = $Times[1]
            "Instructor" = $tds[6].innerText;
            "Location"   = $tds[9].innerText;
        }
    }

    # Call daysTranslator
    $FullTable = daysTranslator($FullTable)


    return $FullTable

}

# Function to translate days
function daysTranslator($FullTable) {
    # Go over every record in table
    for ($i = 0; $i -lt $FullTable.length; $i++) {

        # Empty array
        $Days = @()

        # M = Monday
        if ($FullTable[$i].Days -ilike "M*") { $Days += "Monday" }

        # T followed by T,W, or F = Tuesday
        if ($FullTable[$i].Days -ilike "*T[TWF]*") { $Days += "Tuesday" }

        # Only T = Tuesday
        ElseIf ($FullTable[$i].Days -ilike "T") { $Days += "Tuesday" }

        # W = Wednesday
        if ($FullTable[$i].Days -ilike "*W*") { $Days += "Wednesday" }

        # TH = Thursday
        if ($FullTable[$i].Days -ilike "*TH*") { $Days += "Thursday" }

        # F = Friday
        if ($FullTable[$i].Days -ilike "*F") { $Days += "Friday" }

        # Make switch
        $FullTable[$i].Days = $Days
    }

    return $FullTable
}
