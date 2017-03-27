### Common m4 templates to use for the Docker Build

- meta-data.json.m4 is used by \_scripts\_build-image.sh to create a .json file
to be included into the docker image so it can be referenced later if needed.
The meta contains version information and github commitSHA1 information.

Format:
```
{
  "buildNum": "<build UID will go here from CI ex: 113'>",
  "gitRepository": "<repo name  ex: 'https://github.com/milcom/jsxproxy'>",
  "commitSHA1": "<github commit id ex: '74af95974f17cbd...'>",
  "description": "<some notes>"
}
```
