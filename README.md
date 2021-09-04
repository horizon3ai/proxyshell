# ProxyShell
Proof of Concept Exploit for Microsoft Exchange CVE-2021-34473, CVE-2021-34523, CVE-2021-31207

# Features / Improvments
Blog post detailing additional research the Horizon3 Red Team conducted:
https://www.horizon3.ai/news/blog/proxyshell

* No email address needs to be supplied
* Attempts to enumerate emails from Active Directory
* Attempts to enumerate LegacyDNs from Active Directory
* Attempts to discover LegacyDNs from builtin emails
* Attempts to discover SID of Exchange server in load-balanced deployments
* Handles exploitation in load-balanced environments

# Usage
python exchange_proxyshell.py -u https://<IP>

![Proof](poc.png)

# Prior Research Credit
https://devco.re/blog/2021/08/22/a-new-attack-surface-on-MS-exchange-part-3-ProxyShell/
https://www.zerodayinitiative.com/blog/2021/8/17/from-pwn2own-2021-a-new-attack-surface-on-microsoft-exchange-proxyshell
https://peterjson.medium.com/reproducing-the-proxyshell-pwn2own-exploit-49743a4ea9a1
https://github.com/dmaasland/proxyshell-poc
