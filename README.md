# composite-run-steps-action-template

This template can be used to quickly start a new custom composite-run-steps action repository.  Click the `Use this template` button at the top to get started.

## TODOs
- Readme
  - [ ] Update the Inputs section with the correct action inputs
  - [ ] Update the Outputs section with the correct action outputs
  - [ ] Update the Example section with the correct usage   
- action.yml
  - [ ] Fill in the correct name, description, inputs and outputs and implement steps
- CODEOWNERS
  - [ ] Update as appropriate
- Repository Settings
  - [ ] On the *Options* tab check the box to *Automatically delete head branches*
  - [ ] On the *Options* tab update the repository's visibility
  - [ ] On the *Branches* tab add a branch protection rule
    - [ ] Check *Require pull request reviews before merging*
    - [ ] Check *Dismiss stale pull request approvals when new commits are pushed*
    - [ ] Check *Require review from Code Owners*
    - [ ] Check *Include Administrators*
  - [ ] On the *Manage Access* tab add the appropriate groups
- About Section (accessed on the main page of the repo, click the gear icon to edit)
  - [ ] The repo should have a short description of what it is for
  - [ ] Add one of the following topic tags:
    | Topic Tag       | Usage                                    |
    | --------------- | ---------------------------------------- |
    | az              | For actions related to Azure             |
    | code            | For actions related to building code     |
    | certs           | For actions related to certificates      |
    | db              | For actions related to databases         |
    | git             | For actions related to Git               |
    | iis             | For actions related to IIS               |
    | microsoft-teams | For actions related to Microsoft Teams   |
    | svc             | For actions related to Windows Services  |
    | jira            | For actions related to Jira              |
    | meta            | For actions related to running workflows |
    | pagerduty       | For actions related to PagerDuty         |
    | test            | For actions related to testing           |
    | tf              | For actions related to Terraform         |
  - [ ] Add any additional topics for an action if they apply    
    

## Inputs
| Parameter | Is Required | Description           |
| --------- | ----------- | --------------------- |
| `input-1` | true        | Description goes here |
| `input-2` | false       | Description goes here |

## Outputs
| Output     | Description           |
| ---------- | --------------------- |
| `output-1` | Description goes here |

## Example

```yml
# TODO: Fill in the correct usage
jobs:
  job1:
    runs-on: [self-hosted]
    steps:
      - uses: actions/checkout@v2

      - name: Add the action here
        uses: im-open/this-repo@v1.0.0
        with:
          input-1: 'abc'
          input-2: '123
```


## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).
