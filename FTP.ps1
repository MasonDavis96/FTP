#Get name of directory the files are located in to be zipped
$dirName = Get-ChildItem -Path \\path\to\directory -Directory | ForEach-Object {$_.Name}

# Modify name of zip file that will be created
$zipName = ("modifiedName" + $dirName)


# Compress files into .zip
$compress = @{
    # Path to source folder where files are located
    Path = "\\path\to\directory\*"
    # Path to where .zip will be created
    DestinationPath = "\\path\to\directory\$zipName.zip"
}
Compress-Archive @compress


# Send .zip to ftp server
try
{
    $WebClient = New-Object System.Net.WebClient

    # Zip file to send
    $File = "\\path\to\directory\$zipName.zip"
    # FTP server
    $FTP = "ftp://name:password@ftp/$zipName.zip"

    $URI = New-Object System.Uri($FTP)

    $WebClient.UploadFile($URI, $File)
}
catch
{
    $err=$_
    Write-Host $err.exception.message
}


# Delete everything in the source folder after zip is sent
Remove-Item -Path "\\path\to\directory\*" -Recurse