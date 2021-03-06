---
title: The YumRepos Repository :o)
header-includes:
    <meta name="description" content="Repository for the YumRepos Packages">
    <meta name="author" content="Arne Hilmann <arne.hilmann@gmail.com>">

    <link href="https://fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">

    <link rel="stylesheet" href="css/normalize.css">
    <link rel="stylesheet" href="css/skeleton.css">
    <link rel="stylesheet" href="css/ribbons.css">
    <link rel="stylesheet" href="css/custom.css">

    <link rel="icon" type="image/png" href="images/favicon.png">

    <style>
        .header{background-image:url("images/header3.jpeg");}
        .header, .footer {background-size:cover; color:#ccc;}
        .oncoloredbg, .oncoloredbg * {font-weight:300;text-shadow:0 0 2px black;}
        h4{padding-top:2rem;}
        body{background-color:#f9f9f9;}
        .sidenote{color:#555;font-style:italic;font-size:80%;display:inline-block;width:66%;margin-left:31%;text-align:right;}
        li{padding-left:1rem;text-indent:-1rem;}
        div.column{width:100%;}
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="js/site.js"></script>
---
<div class="section header">
<div class="container oncoloredbg" style="padding-top: 8%; padding-bottom: 3%;">


## YumRepos

Serve RPMs, locally, secure, fast, simple

</div>
</div>

<div class="ribbon right grey"><a href="https://github.com/arnehilmann/yumrepos">Visit me on GitHub</a></div>


<div class="navbar-spacer"></div>

<nav class="navbar">
<div class="container">
<ul class="navbar-list">
<li class="navbar-item"><a class="navbar-link" href="#features">Features</a></li>
<li class="navbar-item"><a class="navbar-link" href="#installation">Installation</a></li>
<li class="navbar-item"><a class="navbar-link" href="#further-questionscomments">On Github</a></li>
</ul>
</div>
</nav>

<div class="container">
<div class="row">
<div class="column" style="margin-bottom: 30%;">


#### Features

With YumRepos, you &hellip;

* have a simple [ReST API](https://github.com/arnehilmann/yumrepos#rest-api),
  to handle your repositories and RPMs,
* have always up-to-date metadata,
  <span class="sidenote">no scheduler to wait/hope for: YumRepos has a synchronous and
  blazingly fast metadata handling!</span>
* serve your repositories as simple static content,
  <span class="sidenote">no complex logic between you and your rpms, just a web server</span>
* deduplicate your RPMs on upload,
  <span class="sidenote">YumRepos uses hardlinks for all 'copies' of the same RPM, so
  no space gets wasted</span>
* might nest your repositories as deep as you need,<br/>
  <span class="sidenote">no need to define a maximum nesting depth upfront</span>
* need just [3 commands](#installation) from "zero" to "working yum repository service".
  <span class="sidenote">okay, you need a CentOS7 machine to start with, afterwards you need at least one set
  of credentials, and there are no repositories or RPMs at all... but: the service is up-n-running, and
  using that service is just a http request away</span>

[This place here](https://github.com/arnehilmann/yumrepos/tree/master/docs)
also hosts the yum repository for the yumrepos rpms
and its centos7 configuration!


#### Installation

_Prerequisites: centos7 machine, with root and internet access_

1. enable epel repos and yum utilities:<br/>
    ```yum install epel-release yum-utils```
2. enable this repo:<br/>
    ```yum-config-manager --add-repo https://arnehilmann.github.io/yumrepos/yumrepos.repo```
3. install yumrepos configuration for centos7:<br/>
    ```yum install yumrepos-0.9.10-py27 yumrepos-behind-nginx-on-centos7```

Now just follow the instructions on your new shiny yumrepos server:<br/>
    visit ```https://localhost/```


#### Further Questions/Comments?

Have a look at the <a href="https://github.com/arnehilmann/yumrepos#rest-api">API</a>.<br/>
And see the <a href="https://github.com/arnehilmann/yumrepos">admin part</a>
or the <a href="https://github.com/arnehilmann/yumrepos-behind-nginx-on-centos7">centos7-specific configuration</a>
of this installation.
