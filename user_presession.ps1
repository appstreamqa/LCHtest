echo "Starting script"

echo "Deleting content in bucket qa-iamroletest"
aws s3 rm s3://qa-iamroletest  --recursive --quiet  --profile machine-role

echo "Printing content in bucket qa-iamroletest"
aws s3 ls s3://qa-iamroletest --profile machine-role

echo "creating file in bucket"
aws s3api put-object --bucket qa-iamroletest  --key testfile  --profile machine-role

echo "Printing content in bucket qa-iamroletest"
aws s3 ls s3://qa-iamroletest --profile machine-role

echo "Try Printing content in bucket qa-iamroletest without mentioning profile"
aws s3 ls s3://qa-iamroletest 

#aws s3 cp s3://ramya-test1/image.png C:\Users\ImageBuilderAdmin\Downloads --profile machine-role

$djname = $env:AppStream_UserName.replace("/","-")
echo $djname


$key = "HKLM:\Software\Amazon\AppStream\Storage\$djname\HomeFolder"
$value = "MountStatus" 
do{
$exists = Get-ItemProperty $key $value -ErrorAction SilentlyContinue
if ($exists -eq $null)  {
$timenow = Get-Date
Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt  "$timenow : Path for Home folders regkey does not exist"
echo "Path for Home folders regkey does not exist"
Start-Sleep -s 1 
} 
}until($exists -ne $null)
do{
$output =  (Get-ItemProperty -Path $key -Name $value).$value 

switch($output) {

    0 {
    $timenow = Get-Date
    Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt "$timenow : Home folders disabled"
	echo "Home folders disabled"
    Start-Sleep -s 1 
    }

    4 {
    $timenow = Get-Date
    Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt "$timenow : Home folders enabled,  mount not started"
	echo "Home folders enabled, mount not started"
    Start-Sleep -s 1 
    }

    1{
    $timenow = Get-Date
    Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt "$timenow : Home folders mount in progress"
	echo "Home folders mount in progress"
    } 
 
    2 {
    $timenow = Get-Date
    Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt  "$timenow : Home folders folders mount successful"
	echo "Home folders folders mount successful"
    } 
     
    3 {
    $timenow = Get-Date
    Add-Content C:\Users\PhotonUser\Downloads\S3_MountStatus.txt  "$timenow : Home folders folders mount failed"
	echo "Home folders folders mount failed"
    }  
}
}until($output -eq 2)

echo "Started copying S3_MountStatus.txt to S3"
Copy-Item -Path 'C:\Users\PhotonUser\Downloads\S3_MountStatus.txt' -Destination 'C:\Users\PhotonUser\My Files\Home Folder'
echo "Completed copying S3_MountStatus.txt to S3"

echo "Started copying S3_MountStatus.txt to S3's IAMAssertion test bucket qa-iamroletest"
aws s3 cp  'C:\Users\PhotonUser\Downloads\S3_MountStatus.txt' s3://qa-iamroletest --profile machine-role
echo "Completed copying S3_MountStatus.txt to S3's IAMAssertion test bucket qa-iamroletest"

echo "Started getting env variables to C:\Users\PhotonUser\Downloads\env_variables_presession.txt"
gci env:* >> C:\Users\PhotonUser\Downloads\env_variables_presession_toS3.txt

echo "Started copying env_variables_presession_toS3.txt to S3"
Copy-Item "C:\Users\PhotonUser\Downloads\env_variables_presession_toS3.txt" -Destination "C:\Users\PhotonUser\My Files\Home Folder"
echo "Completed copying env_variables_presession_toS3.txt to S3"

echo "Started copying env_variables_presession_toS3.txt  to S3's IAMAssertion test bucket qa-iamroletest"
aws s3 cp  'C:\Users\PhotonUser\Downloads\env_variables_presession_toS3.txt' s3://qa-iamroletest --profile machine-role
echo "Completed copying env_variables_presession_toS3.txt to S3's IAMAssertion test bucket qa-iamroletest"

echo Ending pre
exit
