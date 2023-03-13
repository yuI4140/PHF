Set-Alias -Name nvi -Value nvim
Set-Alias -Name new -Value notepad
Set-Alias g git
Set-Alias grep findstr
Set-Alias -Name cc -Value cd..
Set-Alias -Name c -Value cd
Set-Alias -Name mkd -Value mkdir
# move a array of string to a folder or directory
function mvArray {
    param(
        [string[]]$fs,
        [string]$dest
    )

    foreach ($file in $fs) {
        Move-Item -Path $file -Destination $dest -Force
    }
}
# search a extension of files and set the initalial name or alias
# for searching.
function srch_files {
    param(
        [string]$Type,
        [string]$Alias
    )
    
    $vars = @()
    $files = Get-ChildItem -Path .\ -Filter "*.$Type"
    foreach ($file in $files) {
        if ($file.BaseName -like "*$Alias*") {
            $vars += $file.Name
            Write-Host "Found file: $($file.FullName)"
        }
    }
    return $vars
}
function du {
    param(
    [System.String]
    $Path=".",
    [switch]
    $SortBySize,
    [switch]
    $Summary
)
$path = (get-item ".").FullName
$groupedList = Get-ChildItem -Recurse -File $Path | 
    Group-Object directoryName | 
        select name,@{name='length'; expression={($_.group | Measure-Object -sum length).sum } }
$results = ($groupedList | % {
    $dn = $_
    if ($summary -and ($path -ne $dn.name)) {
        return
    }
    $size = ($groupedList | where { $_.name -like "$($dn.name)*" } | Measure-Object -Sum length).sum
    New-Object psobject -Property @{ 
        Directory=$dn.name; 
        Size=Format-FileSize($size);
        Bytes=$size` 
    }
})
if ($SortBySize)
    { $results = $results | sort-object -property Bytes }
$results | more
}