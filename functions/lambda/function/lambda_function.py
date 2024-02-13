import boto3
import json

# Constants for styling and configuration.
SOURCE_EMAIL = 'lupe.medina0612@gmail.com'
DARK_NAVY_COLOR = '#001F3F'
ZEBRA_COLOR_EVEN = '#f2f2f2'
ZEBRA_COLOR_ODD = 'white'
TABLE_WIDTH = '80%'

# links 
NIST_LINK = 'https://appwiki.xom.cloud/docs/SpecializedCloud/AWS/Security/AWSSecurityHubOverview.html'
RESOLVE_FINDING_GUIDE_LINK = 'https://appwiki.xom.cloud/docs/SpecializedCloud/AWS/Security/Remediation/AWSRemediationGuide.html'
AWS_PLATFORM_EMAIL_LINK = 'mailto:GSC-EMIT-HP-PLATFORMS-AWS-AWSPLATFORM.UG@exxonmobil.com'
#SEC_HUB_FILTERED_DASHBOARD = 'https://us-east-1.console.aws.amazon.com/securityhub/home?region=us-east-1#/findings?search=SeverityLabel%3D%255Coperator%255C%253AEQUALS%255C%253ACRITICAL%26SeverityLabel%3D%255Coperator%255C%253AEQUALS%255C%253AHIGH%26WorkflowStatus%3D%255Coperator%255C%253AEQUALS%255C%253ANEW%26RecordState%3D%255Coperator%255C%253AEQUALS%255C%253AACTIVE%26ComplianceStatus%3D%255Coperator%255C%253AEQUALS%255C%253AFAILED'


# AWS service clients. Initialize once for efficiency and reuse.
org_client = boto3.client('organizations')
securityhub_client = boto3.client('securityhub')
ses_client = boto3.client('ses')

# Step 1: Fetch all AWS accounts in the organization.
def list_all_accounts():
    '''
    Returns:
    - list: List of AWS Account IDs in the organization.
    '''
    account_ids = []
    paginator = org_client.get_paginator('list_accounts')
    for page in paginator.paginate():
        for account in page['Accounts']:
            account_ids.append(account['Id'])
    #print("account_ids: ",account_ids)
    return account_ids

# Step 2: Retrieve the email of the account owner and account name from the 
# AWS Organization for the provided account ID.
def get_account_owner_email_and_name(account_id):
    '''
    Parameters:
    - account_id (str): AWS Account ID to fetch for details.
    Returns:
    - tuple: (email, account_name)
    '''
    tagFound=False
    email = None
    account_name = None
    response = org_client.describe_account(AccountId=account_id)
    
    #print ("response: ", response)
    account_name = response['Account']['Name']
    #print ("account_name: ",account_name)
    tags = org_client.list_tags_for_resource(ResourceId=account_id)
    #print("tags: ",tags)
    for tag in tags['Tags']:
        if tag['Key'] == 'Account-Owner1':
            email = tag['Value']
            #email = 'rodrigo.m.sanandres@exxonmobil.com'               # <---------------- Hardcode here the email to send all findings for all accounts to us!
            tagFound=True
            print("email: ",email)
            break
    '''
    if tagFound == False:
        email= "GSC-EMIT-HP-PLATFORMS-AWS-AWSPLATFORM.UG@exxonmobil.com"
        return email, account_name
    '''
    return email, account_name

# Step 3: Construct the HTML email content to send to the account owner.
def send_email(account_id, findings, account_name):
    '''
    Parameters:
    - account_id (str): AWS Account ID for which the findings are reported.
    - findings (list): List of findings details to be reported in the email.
    - account_name (str): Name of the AWS account.
    '''
    sorted_findings = sorted(
        findings, 
        key=lambda f: {'CRITICAL': 0, 'HIGH': 1}.get(f['Severity']['Label'], 2)
    )

    # Constructing the HTML table for findings.
    table_html = f'''
    <table style="width: 100%; border-collapse: collapse; text-align: left; font-family: EMprint, Arial, sans-serif;">
        <thead>
            <tr style="background-color: {DARK_NAVY_COLOR}; color: white;font-size: 16px;">
                <th style="padding: 10px;">Severity</th>
                <th style="padding: 10px;">Title</th>
                <th style="padding: 10px;">Resource ID</th>
                <th style="padding: 10px;">Resource Region</th>
                <th style="padding: 10px;">Remediation</th>
            </tr>
        </thead>
        <tbody>
    '''
    
    # Populate the table rows from findings.
    for idx, finding in enumerate(sorted_findings):
        row_color = ZEBRA_COLOR_EVEN if idx % 2 == 0 else ZEBRA_COLOR_ODD
        table_html += f'''
        <tr style="background-color: {row_color}; border-bottom: 1px solid #ccc;">
            <td style="padding: 10px;">{finding['Severity']['Label']}</td>
            <td style="padding: 10px;">{finding['Title']}</td>
            <td style="padding: 10px;">{finding.get('Resources', [{}])[0].get('Id', 'N/A')}</td>
            <td style="padding: 10px;">{finding.get('Region', 'N/A')}</td>
            <td style="padding: 10px;"><a href="{finding.get('Remediation', {}).get('Recommendation', {}).get('Url', 'N/A')}">Remediation</a></td>
        </tr>
        '''

    table_html += '</tbody></table>'
    
    # Create the complete email body embedding the table.
    email_body = f'''
<!--    <div style="box-sizing: border-box; width: {TABLE_WIDTH}; background-color: #00A3E0; padding: 2in 0in 2in 0in; height: 85pt; font-family: EMprint, Arial, sans-serif;">    -->  
        <img src="https://mysite.na.xom.com/personal/sa_rmvysan/Documents/Shared%20with%20Everyone/xom-platform-blue-to-red.png" alt="ExxonMobil AWS Hosting and Platforms" width="100%" height="333">
<!--         <h1 style="box-sizing: border-box; color: {DARK_NAVY_COLOR}; margin: 0; text-align: center; padding: 20px;">ExxonMobil AWS Hosting and Platforms</h1>    -->  
<!--    </div>      -->  
    <br>
    <br>
    <div style="box-sizing: border-box; width: {TABLE_WIDTH}; margin: 0 auto; padding: 20px 0; font-family: EMprint, Arial, sans-serif;">
        <h2 style="box-sizing: border-box; color: {DARK_NAVY_COLOR}; text-align: center; padding: 20px; margin: 0;">Failed Security Hub Findings for Account {account_id} ({account_name})</h2>
        <br>
        <h3><strong>Why Am I Receiving This Notification?</strong></h3>
        <p>Specific resources in your AWS account have been identified as non-compliant with ExxonMobil's <a href="{NIST_LINK}">security standards</a>.</p>
        <p>Ensuring the security of our AWS resources is a shared responsibility.</p>
    
        <h3><strong>What Are My Next Steps?</strong></h3>
        <ol>
            <li>Go the <a href="{RESOLVE_FINDING_GUIDE_LINK}">Remediation Guide</a>.</li>
            <li>Immediately address any "CRITICAL" findings.</li>
            <li>Subsequently, prioritize "HIGH" findings.</li>
        </ol>
<!--        <p>For guidance, please refer to this <a href="{RESOLVE_FINDING_GUIDE_LINK}">resolution guide</a>.</p>  -->
    
<!--        <h3><strong>What If I Take No Action?</strong></h3>   -->
<!--        <p>Failure to address these findings will result in escalation to cybersecurity. This may lead to each unresolved finding being classified as a Vulnerability and Threat Control (VTC) and potential account interruption. Remember, ensuring the security of our AWS resources is a shared responsibility.</p>   -->
    
        <h3><strong>Assistance or Queries?</strong></h3>
        <p>For any assistance or questions, do not hesitate to reach out to the <a href="{AWS_PLATFORM_EMAIL_LINK}">AWS Platform Team</a>.</p>
        
        <h4 style="text-align: center;">Security Hub Findings Table</h4>
        {table_html}        
    </div>
    '''
    email_address, _ = get_account_owner_email_and_name(account_id)
    if email_address:
        try:
            ses_client.send_email(
                Source=SOURCE_EMAIL,
                Destination={'ToAddresses': [email_address]},
                Message={
                    'Subject': {'Data': 'AWS Security Hub Findings - Action Required'},
                    'Body': {'Html': {'Data': email_body}},
                }
            )
        except Exception as e:
            print(f"Error sending email for account {account_id}: ", e)

# Step 4: Fetch findings from AWS Security Hub for a specific account based on the given filters.
def get_findings_for_account(account_id, filters):
    '''
    Parameters:
    - account_id (str): AWS Account ID to fetch the findings for.
    - filters (dict): Filters to apply to the AWS Security Hub findings query.
    Returns:
    - list: List of findings that match the filters for the specified account.
    '''
    findings = []
    paginator = securityhub_client.get_paginator('get_findings')
    for page in paginator.paginate(Filters=filters):
        findings.extend([f for f in page['Findings'] if f['AwsAccountId'] == account_id])
    return findings

# Step 5: AWS Lambda function entry point.
def lambda_handler(event, context):
    '''
    Retrieves 'FAILED' findings with 'HIGH' or 'CRITICAL' severity, Workflow status 'NEW',
    and record state 'ACTIVE' from AWS Security Hub.
    then sends an email report of these findings to each account owner. If the "Account-Owner2" tag is not found for an account,
    it will print that account's ID with a message "Email Tag Not Found".
    '''
    combined_filters = {
        'ComplianceStatus': [{'Value': 'FAILED', 'Comparison': 'EQUALS'}],
        'SeverityLabel': [
            {'Value': 'HIGH', 'Comparison': 'EQUALS'},
            {'Value': 'CRITICAL', 'Comparison': 'EQUALS'}
        ],
        'WorkflowStatus': [
            {'Value': 'NEW', 'Comparison': 'EQUALS'},
            {'Value': 'NOTIFIED', 'Comparison': 'EQUALS'}
        ],
        'RecordState': [{'Value': 'ACTIVE', 'Comparison': 'EQUALS'}]
    }
    
    
    
    missing_email_tag_accounts = []
    accounts_list_notification = []
    
    list_accounts = list_all_accounts()
    #list_accounts = accounts_list_notification = ['411767108543','560714334915','501857088953']
    #list_accounts = accounts_list_notification = ['411767108543','560714334915','501857088953','707960056492','783453389855','840484897615','836642691610','024432107588']        # <----------- to restrict amount of accounts that we send the notification. To modify this behavior and send it to everyone, just delete this line or increase the list with more account_ids (also delete line 193 to remove the var accounts_list_notification). 
    #list_accounts = accounts_list_notification = ['707960056492','783453389855','836642691610','024432107588','849502268560','560714334915','416866921577','219717596235','875374572151','612108445681','509908249861','840484897615','931409472801','501857088953','936409623761','324629311062']  
    # ^
    # |
    # |____This is to restrict the amount of accounts that we send the notification. To modify this behavior and send it to everyone, just delete this line (196) and also  line 193 to remove the var "accounts_list_notification" (otherwise to extend it to more accounts, just add the accounts_ids as "str in "accounts_list_notification" var. 
    
    for account_id in list_accounts:    
        email, account_name = get_account_owner_email_and_name(account_id)
        if email:
            findings = get_findings_for_account(account_id, combined_filters)
            if findings:
                send_email(account_id, findings, account_name)
        else:
            missing_email_tag_accounts.append(account_id)

    if missing_email_tag_accounts:
        send_missing_email(missing_email_tag_accounts)
        print("Email Tag Not Found for the following account IDs:", ', '.join(missing_email_tag_accounts))

    return {
        'statusCode': 200,
        'body': json.dumps('Emails Sent Successfully!')
    }

# Step X: Construct the HTML email content to send to AWS-Platform team for account without proper Account-Owner tag (with its email).
def send_missing_email(account_ids):
    # Constructing the HTML table for findings.
    table_html = f'''
    <table style="width: 30%; border-collapse: collapse; text-align: left; font-family: EMprint, Arial, sans-serif;">
        <thead>
            <tr style="background-color: {DARK_NAVY_COLOR}; color: white;font-size: 16px;">
                <th style="padding: 10px;">Account IDs without proper email Tag</th>
            </tr>
        </thead>
        <tbody>
    '''
    
    # Populate the table rows from findings.
    for idx, account_id in enumerate(account_ids):
        row_color = ZEBRA_COLOR_EVEN if idx % 2 == 0 else ZEBRA_COLOR_ODD
        table_html += f'''
        <tr style="background-color: {row_color}; border-bottom: 1px solid #ccc;">
            <td style="padding: 10px;">{account_id}</td>
        </tr>
        '''
    table_html += '</tbody></table>'
    # Create the complete email body embedding the table.
    email_body2 = f'''
        {table_html}        
    </div>
    '''

    try:
        ses_client.send_email(
            Source=SOURCE_EMAIL,
            Destination={'ToAddresses': ["rodrigo.m.sanandres@exxonmobil.com"]},
            Message={
                'Subject': {'Data': 'Security Hub Findings email missing!!!!!'},
                'Body': {'Html': {'Data': email_body2}},
            }
        )
    except Exception as e:
        print(f"Error sending email for account {account_id}: ", e)
