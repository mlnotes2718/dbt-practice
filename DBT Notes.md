# DBT Setup Notes

## Requirements
- Need Google account and Sign-up with Bigquery
- Use `gcloud auth application-default login` to create easy access to Google Bigquery
- Get Google Bigquery Project name ready, if not create a new project.
- In Bigquery, create a dataset to use (This is optional, DBT able to create dataset for you)

## Key DBT Commands
The following are DBT common key commands:
- `dbt init <dbt-project-name>` : DBT init perform 2 tasks, set the a subfolder with the project name and also populate a structure subfolder that DBT required. DBT also setup connection profile automatically including its authentication methods. This command is not suitable for existing project. Please run this command under the root folder if you have many projects.

The following command **MUST** be run under the specific project folder.
- `dbt debug` : Use this command to verified your connection in your profile.
- `dbt run` : Use this command to run all the SQL script setup in the DBT folders.
- `dbt test` : Use this command to test the database field. Similar to constraints during database table setup. However, DBT uses schema.yml file for configuration
- `dbt seed` : Use this command to convert CSV files into database table
- `dbt snapshot` : Use this command to build snapshot 


## DBT init

Reference: https://docs.getdbt.com/reference/commands/init

When we initiate `dbt init <dbt-project-name>`, DBT will perform 2 tasks below:
1. DBT init first task is to create all the necessary subfolder for your project under the name of your project. If there is an existing folder with the same name as the project name, the init will fail.
2. Next DBT will setup your profile automatically, this includes setting up your authentication method to the data warehouse.

### DBT Folder Setup
- If there is an existing folder that is same as the project name. It will failed.
- **Please check your directory location! Please do not perform init within another DBT project. Always start init at the root folder.**


### DBT Profile
Please note that there are multiple ways for DBT to work with profile, they are:
- Automatic profile setup, DBT will always look at the default profile.yml located at `/Users/USER/.dbt/profile.yml`. If DBT found the same project name under your default profile, it will ask if you want to overwrite it. Otherwise, DBT will configure the profile over there. This is the recommend as the profile may contain sensitive information that is not appropriate for Github exposure.
- Using existing profile setup by ourselves. We can supplied and configure our own profile.

### DBT Authentication
- oauth : If you have previously use `gcloud auth application-default login` in your environment, oauth is recommend as no extra steps is needed.
- service account : You need to create a service key in json from Google. This service key need to reside on a secure location that is accessible by the DBT system. A recommended location is the same location as the default profile (`profiles.yml`) location; which is at (`/Users/USER/.dbt/`). On how to generate service key please refer to this page: https://docs.getdbt.com/guides/bigquery?step=4.

### DBT init - Automatic Profile Creation with Oauth
- **Please check your directory location! Please do not perform init within another DBT project. Always start init at the root folder. Init will fail if there is an existing folder with the same project name.**
- When you run `dbt init <dbt-project-name>` it will create a folder with that project name and all the necessary subfolder.
- Next it will automatically create a connection profile for you, based on the answer you supplied. For Mac user, the profile is located at `/Users/USER/.dbt/profile.yml`

#### Automatic Profile Setup Question
- Which database would you like to use? >> Select [1] bigquery
- Desired authentication method option (enter a number): >> Select 1 for oauth, 2 for service account
- project (GCP project id): >> YourGoogleProject
- dataset (the name of your dbt dataset): >> shaffle_shop (Note: you can specified the dataset you created on Bigquery, if you did not create a dataset, DBT will create one using the dataset name you supplied here)
- threads (1 or more): >> enter a thread number
- job_execution_timeout_seconds [300]: >> enter for default
- Desired location option (enter a number): 1 for US and 2 for EU

**Example**
The following is a sample of automatic init
```text
% dbt init shaffle_shop
05:56:30  Running with dbt=1.9.2
05:56:30  [ConfigFolderDirectory]: Unable to parse logging event dictionary. Failed to parse dir field: expected string or bytes-like object.. Dictionary: {'dir': PosixPath('/Users/USER/.dbt')}
05:56:30  Creating dbt configuration folder at 
05:56:30  
Your new dbt project "shaffle_shop" was created!

For more information on how to configure the profiles.yml file,
please consult the dbt documentation here:

  https://docs.getdbt.com/docs/configure-your-profile

One more thing:

Need help? Don't hesitate to reach out to us via GitHub issues or on Slack:

  https://community.getdbt.com/

Happy modeling!

05:56:30  Setting up your profile.
Which database would you like to use?
[1] bigquery

(Don't see the one you want? https://docs.getdbt.com/docs/available-adapters)

Enter a number: 1
[1] oauth
[2] service_account
Desired authentication method option (enter a number): 1
project (GCP project id): bigquery-project-name
dataset (the name of your dbt dataset): dataset-name
threads (1 or more): 2
job_execution_timeout_seconds [300]: 
[1] US
[2] EU
Desired location option (enter a number): 1
05:59:28  Profile shaffle_shop written to /Users/USER/.dbt/profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.
```
**Checking Profile**
Under the folder `/Users/USER/.dbt/profiles.yml`, you should have something similar:
```shell
jaffle_shop: # DBT project name
  outputs:
    dev: # Target, usually dev or prod to differentiate between development and production
      dataset: shaffle_shop #(google dataset, in this case I use the same name with the project name)
      job_execution_timeout_seconds: 300
      job_retries: 1
      location: US
      method: oauth
      priority: interactive
      project: bigquery-project-name
      threads: 1
      type: bigquery
  target: dev
```

### DBT init - Automatic Profile Creation with Service Account
- **Please check your directory location! Please do not perform init within another DBT project. Always start init at the root folder. Init will fail if there is an existing folder with the same project name.**
- When you run `dbt init <dbt-project-name>` it will create a folder with that project name and all the necessary subfolder.
- Next it will automatically create a connection profile for you, based on the answer you supplied. For Mac user, the profile is located at `/Users/USER/.dbt/profile.yml`

#### Automatic Profile Setup Question
- Which database would you like to use? >> Select [1] bigquery
- Desired authentication method option (enter a number): >> 2 (Select 1 for oauth, 2 for service account)
- keyfile (/path/to/bigquery/keyfile.json): /Users/USER/.dbt/name-of-your-service-key-created-in-Google.json
- project (GCP project id): >> YourGoogleProject
- dataset (the name of your dbt dataset): >> **liquor_sales** (Note: you can specified the dataset you created on Bigquery, if you did not create a dataset, DBT will create one using the dataset name you supplied here)
- threads (1 or more): >> enter a thread number
- job_execution_timeout_seconds [300]: >> enter for default
- Desired location option (enter a number): 1 for US and 2 for EU

**Example**
The following is an example, the process is teh same except that we use service account.
```text
% dbt init liquor_sales
09:09:22  Running with dbt=1.9.2
09:09:22  
Your new dbt project "liquor_sales" was created!

For more information on how to configure the profiles.yml file,
please consult the dbt documentation here:

  https://docs.getdbt.com/docs/configure-your-profile

One more thing:

Need help? Don't hesitate to reach out to us via GitHub issues or on Slack:

  https://community.getdbt.com/

Happy modeling!

09:09:22  Setting up your profile.
Which database would you like to use?
[1] bigquery

(Don't see the one you want? https://docs.getdbt.com/docs/available-adapters)

Enter a number: 1
[1] oauth
[2] service_account
Desired authentication method option (enter a number): 2
keyfile (/path/to/bigquery/keyfile.json): /Users/USER/.dbt/name-of-your-service-key-created-in-Google.json
project (GCP project id): bigquery-project-name
dataset (the name of your dbt dataset): iowa_liquor_sales
threads (1 or more): 1
job_execution_timeout_seconds [300]: 
[1] US
[2] EU
Desired location option (enter a number): 1
09:11:08  Profile liquor_sales written to /Users/USER/Documents/VSCode-Git/dbt-practice/profiles.yml using target's profile_template.yml and your supplied values. Run 'dbt debug' to validate the connection.
```

**Checking Profile**
Under the folder `/Users/USER/.dbt/profiles.yml`, you should have something similar:
```shell
liquor_sales:
  outputs:
    dev:
      dataset: iowa_liquor_sales # This dataset is not create in Bigquery yet. ABT should able to create it automatically.
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /Users/USER/.dbt/name-of-your-service-key-created-in-Google.json
      location: US
      method: service-account
      priority: interactive
      project: bigquery-project-name
      threads: 2
      type: bigquery
  target: dev

```

### DBT init - Custom Profile Creation with Oauth
The following is to initialize a DBT project using existing profile:

First we need a profile setup, see a sample profile:
```yaml
## Custom DBT profile
## Reference: https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup

# The first line is the dbt project name. This is where dbt looks for from dbt_project.yml -> find the named profile here. 
# Can also be overwritten by dbt run --profiles. See dbt run --help for more info
london_bicycle: # dbt project name
  # default target for profile, points to 1 of the output below # define target in dbt CLI via --target
  target: dev # Usually either dev or production
  outputs:
    threads: 1
    location: EU
    priority: interactive
    dev:
      type: bigquery
      method: oauth 
      project: bigquery-project-name
      dataset: london_bike # can be same or different from project name
      retries: 2
  config:
    send_anonymous_usage_stats: False
```

**IMPORTANT NOTES:**
- **The profile name has to be `profiles.yml`.**
- **The profile need to be located where you run `dbt init`, otherwise dbt will use to the default profile location.**

**Where to put the profile:**
- **We can place the `profiles.yml` at the root folder where we collected all different DBT projects. The profiles of additional DBT projects will be recorded under `profiles.yml`.**
- **Alternatively, we can place the profile (`profiles.yml`) into each project folder. This means that each project folder contains one profile configuration. In this case you need to physically move the file `profiles.yml` to the project subMore will be explain under `dbt debug`.**

The command to run the initialization is `dbt init --profile <dbt-project-name-in-profiles>`. You can also run `dbt init` where it will ask you to enter the project name. After that it will ask if you want to reset the profile configuration in your current profile.

**Example**
The following is a sample of the command output:
```text
% dbt init --profile london_bicycle
08:49:55  Running with dbt=1.9.2
Enter a name for your project (letters, digits, underscore): london_bicycle
08:50:03  
Your new dbt project "london_bicycle" was created!

For more information on how to configure the profiles.yml file,
please consult the dbt documentation here:

  https://docs.getdbt.com/docs/configure-your-profile

One more thing:

Need help? Don't hesitate to reach out to us via GitHub issues or on Slack:

  https://community.getdbt.com/

Happy modeling!
```




## Verifying DBT Connections : dbt debug
