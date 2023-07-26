Import-Module ActiveDirectory

$employees =  Get-ADUser -Filter {(Enabled -eq $True)} -Properties employeeNumber 
$failedInstances = @()
foreach($employee in $employees){
    $employeeNum = $employee.employeeNumber 
    <#
    Proper format of UKG employee number is 6 digits. Logic below is to confirm this format.
    Try to convert $employeeNum to int and back to string. If it is not in number format it will fail and go to catch.  
    If $employeeNum is not equal to 6 it is malformed and should be added to failed instances. 
    When converted to int and back to string it will get rid of decimals so if length is not equal to 6 it had a decimal and should be added to failed instances.
    #>
    try{
            $strIntEmployeeNum = [string][int]$employeeNum
            if( $strIntEmployeeNum.Length -ne 6 -or $employeeNum.Length -ne 6){
                $failedInstances += $employee
        	}        
	}
	catch{
        	$failedInstances += $employee
	} 
}

$failedInstances| select userName, UserPrincipalName, employeeNumber | Export-Csv -NoType C:\Users\Parzival\Desktop\Temp\failedInstances.csv
