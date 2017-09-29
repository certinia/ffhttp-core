## Latest

### BREAKING CHANGES
New methods and removed methods from [ffhttp_Client.ICredentials](https://github.com/financialforcedev/ffhttp-core/blob/505e47ee76dfc469b5c09a70a7f84ff7df7a2576/src/classes/ffhttp_Client.cls#L186).
This interface now represents either a named credential or an access token credential.

### NEW FEATURES

* [Named credential support](https://github.com/financialforcedev/ffhttp-core/pull/7)
	```java
	ffhttp_Client.ICredentials credentials = new ffhttp_Client.NamedCredentials('MyNamedCredential');
	ffhttp_OAuthClient client = new ffhttp_OAuthClient();
	client.setCredentials(credentials);
	```

## v1.0.0

First major release