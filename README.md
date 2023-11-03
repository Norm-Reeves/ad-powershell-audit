# ad-powershell-audit

A PowerShell script designed to audit Active Directory for compliance with our organizational standards.

## Audit Details:

### User Audit:
- Checks that the Employee ID adheres to the format of 6 digits (######).

## Requirements:

- RSAT needs to be installed for this script to work.

## How It Works:

1. The script fetches all AD users that are enabled.
2. It excludes specific organizational units and user groups for auditing.
3. For the remaining users, it ensures that their Employee ID is in the proper 6-digit format.
4. Users who don't meet this criteria are logged as failed instances.
5. The script also checks for users created within the last 30 days and excludes them from the audit.
6. The failed instances are then exported to a CSV file for further examination.

## Change Log:

### Version 1.0:
- Initial release.
- Core feature: Audits employee ID to ensure it's in the 6-digit format (######).

### Version 1.1:
- Enhanced DN exclusion list to cater to additional organizational units and user groups.
- Added feature to exclude users created within the last 30 days from the audit.
- The exported CSV now includes the `whenCreated` property to provide more information on each failed instance.
- Minor script optimizations for improved efficiency.

## Future Enhancements:
- Continuous integration with AD updates.
- Automated alerts for users not adhering to the specified format.
- Integration with ticketing system for automated ticket creation for failed instances.

---

To contribute to this script or if you have any queries, please reach out to the Cloud Services Engineer. We appreciate the feedback and are continually striving to enhance our tools to serve the organization better.
