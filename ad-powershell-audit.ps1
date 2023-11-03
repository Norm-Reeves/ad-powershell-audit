<#
    ad-powershell-audit v1.1
    Author: Jerry Cuevas 
    Date: 11/03/2023
    Organiztion: Normreeves - IT Department 
    Role: Deployment Specialist
#>

#Start

# Define the properties you need
$properties = @('sn','enabled', 'DistinguishedName','Name','UserPrincipalName','legalLastName','employeeNumber', 'whenCreated')

# Get the current date
$currentDate = Get-Date

# Get all AD users that are enabled and specify the properties you need
$employees = Get-ADUser -Filter 'Enabled -eq $True' -Properties $properties

$failedInstances = @()

# Define patterns that indicate users to exclude based on their DistinguishedName
$excludePatterns = @(
    'OU=Domain Admins,',
    'OU=Disabled Users',
    'OU=Vendors,',
    'OU=Vendor',
    'OU=Kiosks',
    'OU=Privileged Accounts',
    'CN=Managed Service Accounts,',
    'CN=Administrator',
    'CN=autobot',
    'CN=Qualys',
    'CN=ch-sales',
    'CN=MarkVision',
    'CN=test2-om',
    'CN=test1-om',
    'CN=MSOL_93b0bfab609e',
    'CN=MSOL_37474fc9f182',
    'CN=Security Test'
    # ... other distinguished name parts to exclude ...
)

foreach ($employee in $employees) {
    # Check if the user is part of any of the excluded DN
     <#
    Proper format of UKG employee number is 6 digits. Logic below is to confirm this format.
    Try to convert $employeeNum to int and back to string. If it is not in number format it will fail and go to catch.  
    If $employeeNum is not equal to 6 it is malformed and should be added to failed instances. 
    When converted to int and back to string it will get rid of decimals so if length is not equal to 6 it had a decimal and should be added to failed instances.
    #>
    $exclude = $false
    foreach ($pattern in $excludePatterns) {
        if ($employee.DistinguishedName -like "*$pattern*") {
            $exclude = $true
            break
        }
    }

    # Skip users created in the last 30 days
    if ($employee.whenCreated -gt $currentDate.AddDays(-30)) {
        continue
    }

    # If the user is not part of the excluded DNs, then process their employee number
    if (-not $exclude) {
        $employeeNum = $employee.employeeNumber 

        try {
            $strIntEmployeeNum = [string][int]$employeeNum
            if ($strIntEmployeeNum.Length -ne 6) {
                $failedInstances += $employee
            }        
        }
        catch {
            $failedInstances += $employee
        }
    }
}

$failedInstances | Select-Object Name, UserPrincipalName, employeeNumber, DistinguishedName, whenCreated | Export-Csv -NoTypeInformation -Path C:\Users\Parzival\Desktop\Temp\failedInstances_v2DEBUG.csv | out-null

#END
