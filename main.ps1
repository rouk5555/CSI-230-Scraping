. (Join-Path $PSScriptRoot Web-Scraper.ps1)

clear

$FullTable = gatherClasses

# Various queries
$FullTable | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | `
            Where-Object { $_.Instructor -eq "Furkan Paligu" }

$FullTable | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.days -icontains "Monday") } | `
            Sort-Object "Time Start" | `
            Format-Table "Time Start", "Time End", "Class Code"
 
$ITSInstructors = $FullTable | Where-Object { ($_."Class Code" -ilike "SYS*") -or `
                                              ($_."Class Code" -ilike "NET*") -or `
                                              ($_."Class Code" -ilike "SEC*") -or `
                                              ($_."Class Code" -ilike "FOR*") -or `
                                              ($_."Class Code" -ilike "CSI*") -or `
                                              ($_."Class Code" -ilike "DAT*") } `
                             | Select-Object "Instructor" `
                             | Sort-Object "Instructor" -Unique

$FullTable | where { $_.Instructor -in $ITSInstructors.Instructor } `
           | Group-Object "Instructor" | Select-Object Count,Name | Sort-Object Count -Descending