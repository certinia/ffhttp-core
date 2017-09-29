Apex HTTP Callout Framework
===========================

[![Deploy to scratch org](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com) - Use this button to deploy into an empty scratch org via SFDX.
[![Deploy to SF](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png)](https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=ffhttp-core) - Use this button to deploy into an existing org.


Introduction
------------

An Apex framework has been created to provide functionality for HTTP callouts. This **Core** library has been extended by five libraries [Google Cloud Print](https://github.com/financialforcedev/ffhttp-googlecloudprint), [Google Drive](https://github.com/financialforcedev/ffhttp-googledrive), [Google Mirror](https://github.com/financialforcedev/ffhttp-googlemirror), [Google Sheets](https://github.com/financialforcedev/ffhttp-googlesheets) and [Dropbox](https://github.com/financialforcedev/ffhttp-dropbox).

The **Google Cloud Print** library extends the **Core** library to provide access to Google Cloud Print API calls found at https://developers.google.com/cloud-print/.

The **Google Drive** library extends the **Core** library to provide access to Google Drive API calls found at https://developers.google.com/drive/v2/reference/.

The **Google Mirror** library extends the **Core** library to provide access to Google Mirror API calls found at https://developers.google.com/glass/v1/reference/.

The **Google Sheets** library extends the **Core** library to provide access to Google Sheets API calls found at https://developers.google.com/google-apps/spreadsheets/.

The **Dropbox** library extends the **Core** library to provide access to Dropbox API calls found at https://www.dropbox.com/developers/core/docs.

Sample applications have been created for the [Core](https://github.com/financialforcedev/ffhttp-core-samples), [Google Cloud Print](https://github.com/financialforcedev/ffhttp-googlecloudprint-samples), [Google Drive](https://github.com/financialforcedev/ffhttp-googledrive-samples), [Google Mirror](https://github.com/financialforcedev/ffhttp-googlemirror-samples), [Google Sheets](https://github.com/financialforcedev/ffhttp-googlesheets-samples)) and [Dropbox](https://github.com/financialforcedev/ffhttp-dropbox-samples) libraries to demonstrate the use of this library within Salesforce.

Key Features
------------
+ Framework for HTTP callouts.
+ JSON serialization and deserialization base classes.
+ OAuth Client - extends the base AbstractClient to provide the callouts required for OAuth authentication.

Reporting Issues & Enhancements
-------------------------------
Please report any issues using the github [issues](https://github.com/financialforcedev/ffhttp-core/issues) feature. Suggestions / bug reports are welcome as are extensions containing additional functionality.
