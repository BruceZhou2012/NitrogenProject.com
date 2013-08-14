% vim: ts=4 sw=4 et
-module (downloads).
-include_lib ("nitrogen_core/include/wf.hrl").
-compile(export_all).

-define(UNIX_SERVERS,[
        {cowboy,"Cowboy"},
        {inets,"Inets"},
        {mochiweb,"Mochiweb"},
        {webmachine,"Webmachine"},
        {yaws,"Yaws"}
    ]).

-define(WINDOWS_SERVERS,[
        {cowboy,"Cowboy"},
        {inets,"Inets"},
        {mochiweb,"Mochiweb"}
    ]).

-define(VERSIONS, [
        "2.2.0",
        "2.1.0",
        "2.0.4",
        "2.0.3",
        "2.0.2",
        "2.0.1",
        "2.0.0",
        "1.0"]).

main() -> #template { file="./templates/grid.html" }.

title() -> "Downloads".

layout() -> 
    #container_12 { body=[
        common:github_fork(),
        #grid_12 { class=header, body=common:header(downloads) },
        #grid_clear {},

        #grid_10 { alpha=true, omega=true, prefix=1, suffix=1, class=headline, body=headline() },
        #grid_clear {},

        #grid_5 { prefix=1, alpha=true, body=left(), class=pad_right },
        #grid_5 { suffix=1, omega=true, body=right() },
        #grid_clear {},

        #grid_12 { body=common:footer() }
    ]}.

headline() -> "Downloads".

left() -> 
    CurVer = hd(?VERSIONS),    
    [
        " 
        Select a link to the right to download the Nitrogen ",CurVer,"
        environment for your platform. Each download is a self-contained
        installation of Nitrogen that includes both Erlang and a web 
        server. (In other words, you don't need to have Erlang installed 
        to run this.)
        <p>
        You have a choice between three popular Erlang web servers:
        <p>
        <ul>
        <li>Mochiweb - HTTP server developed by Bob Ippolito/MochiMedia.</li>
        <li>Yaws - HTTP server developed by Claes \"Klacke\" Wikstrom.</li>
        <li>Cowboy - HTTP server developed by Loïc Hoguin.</li>
        <li>Webmachine - HTTP resource server developed by Basho Technologies (runs on Mochiweb under the hood.)</li>
        <li>Inets - Lightweight HTTP server built into Erlang.
        </ul>
        <p>
        Either Mochiweb, Webmachine, Cowboy, or Yaws is recommended for
        production use. Whichever one you choose is up to personal
        preference, but Inets is not recommended for running in
        production because it does not yet include
        content-caching/expiration headers, which can cause slow
        loadtimes.
        <p>
        These packages were generated from Nitrogen source code by running 
        <b>make package_inets</b>, <b>make package_cowboy</b>, 
        <b>make package_mochiweb</b>, <b>make package_webmachine</b> and 
        <b>make package_yaws</b>.
        <p>
        Alternatively, if you plan on contributing to the Nitrogen
        source code, you can download the source tree from GitHub.

        " 
    ].

%% Servers is tuple list = [{"Mochiweb",mochiweb},...]
list_download_links(PlatformLabel,PlatformPath,Version,Ext,Servers) ->
    [format_download_link(PlatformLabel,PlatformPath,Version,Ext,Server) || Server <- Servers].

format_download_link(PlatformLabel,PlatformPath,Version,Ext,{ServerPath,ServerName}) ->
    URL = wf:to_list([
        "http://downloads.nitrogenproject.com.s3.amazonaws.com",
        "/",Version,"/",PlatformPath,
        "/nitrogen-",Version,"-",ServerPath,Ext
    ]),
    Label = wf:to_list([
        "Nitrogen ",Version," for ",PlatformLabel," on ",ServerName
    ]),

    #link {
        class=link,
        url=URL,
        text=Label
    }.

list_source_download_links(Versions) ->
    [format_source_download_link(V) || V <- Versions].

format_source_download_link(Version) ->
    #link{
        class=link,
        url=wf:to_list(["http://github.com/nitrogen/nitrogen/tarball/v",Version]),
        text=wf:to_list(["Download Nitrogen ",Version," source (.tar.gz)"])
    }.


right() ->
    [CurrentVersion | OldVersions] = ?VERSIONS,

    [
        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/documentation.png" }
            ]},
            #span { class=title, text="Nitrogen Documentation" },
            #link { class=link, url="/doc/index.html", text="View Documentation Online" },
            #link { class=link, url="/doc/tutorial.html", text="View the Nitrogen Tutorial" },
            "Docs are also included in platform downloads."
        ]},

        #panel { class=clear },

        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/erlang_logo.png" }
            ]},
            #span { class=title, text="Source Code" },
            list_source_download_links([CurrentVersion]),
            #link { url="http://github.com/nitrogen/nitrogen/tarball/master", text="Download Latest Code (.tar.gz)" },
            #link { url="http://github.com/nitrogen", text="Master Nitrogen repositories on GitHub" },
            #link { url="http://github.com/rshestakov/nitrogen_elements", text="Community Repository of Nitrogen Elements" }
        ]},

        #panel { class=clear },

        #p{},
        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/mac_logo.png" }
            ]},
            #span { class=title, text="Mac OSX 10.6+ Binaries" },
            list_download_links("Mac OSX", "mac/64bit", CurrentVersion, ".tar.gz", ?UNIX_SERVERS)
        ]},

        #panel { class=clear },

        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/linux_logo.png" }
            ]},
            #span { class=title, text="Linux 64-bit Binaries" },
            list_download_links("Linux", "linux/64bit", CurrentVersion, ".tar.gz", ?UNIX_SERVERS)
        ]},

        #panel { class=clear },

        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/windows_logo.png" }
            ]},
            #span { class=title, text="Windows Binaries" },
            list_download_links("Windows","win/32bit", CurrentVersion, "-win.zip", ?WINDOWS_SERVERS)
        ]},

        #panel { class=clear },


        #panel { class=platform, body=[
            #panel { class=logo, body=[
                #image { image="/images/downloads/erlang_logo.png" }
            ]},
            #span { class=title, text="Old Source Code" },
            list_source_download_links(OldVersions)
        ]}
    ].

