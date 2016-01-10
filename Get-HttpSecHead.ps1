#Requires -version 3
#
Function Get-HttpSecHead
{
    <#
            .Synopsis
            Retrive HTTP Headers from target webserver
            .Description
            This command will get the HTTP headers from the target webserver and test for the presence of variuos security related HTTP headers and also display the cookie information.

            Written by Dave Hardy, davehardy20@gmail.com @davehrdy20

            Version 0.1

            .Example
            PS C:> Get-Httphead -url https://www.linkedin.com

            Header Information for https://www.linkedin.com

            Key                       Value                                                                                                                                            
            ---                       -----                                                                                                                                            
            X-FS-UUID                 2f90ea20d61c281480616685e02a0000                                                                                                                 
            X-Page-Speed              1                                                                                                                                                
            X-Frame-Options           sameorigin                                                                                                                                       
            X-Content-Type-Options    nosniff                                                                                                                                          
            X-Li-Fabric               prod-ltx1                                                                                                                                        
            Strict-Transport-Security max-age=0                                                                                                                                        
            Content-Type              text/html; charset=utf-8                                                                                                                         
            Date                      Sun, 10 Jan 2016 16:16:25 GMT                                                                                                                    
            Set-Cookie                lang="v=2&lang=en-us"; Path=/; Domain=linkedin.com,JSESSIONID="ajax:3001827061456051750"; Path=/; Domain=.www.linkedin.com,bcookie="v=2&52f4f9...
            Server                    Play                                                                                                                                             
            Pragma                    no-cache                                                                                                                                         
            Expires                   Thu, 01 Jan 1970 00:00:00 GMT                                                                                                                    
            Cache-Control             no-cache, no-store                                                                                                                               
            Transfer-Encoding         chunked                                                                                                                                          
            Connection                keep-alive                                                                                                                                       
            X-Li-Pop                  prod-tln1                                                                                                                                        
            X-LI-UUID                 L5DqINYcKBSAYWaF4CoAAA==                                                                                                                         




            HTTP security Headers
            Consider adding the values in RED to improve the security of the webserver. 

            X-XSS-Protection Header MISSING
            Strict-Transport-Security Header PRESENT
            Content-Security-Policy Header MISSING
            X-Frame-Options Header PRESENT
            X-Content-Type-Options Header PRESENT
            Public-Key-Pins Header MISSING


            Cookies Set by https://www.linkedin.com
            Inspect cookies that don't have the HTTPOnly and Secure flags set.


            JSESSIONID = "ajax:3001827061456051750"
            HTTPOnly Flag Set = False
            Secure Flag Set = False
            Domain = .www.linkedin.com 

            bscookie = "v=1&2016011016162553e9dcc3-2b9c-46f0-8256-567060481ba9AQGtXnXhM9bGqUX1OCg2nZArYZ1-q22J"
            HTTPOnly Flag Set = True
            Secure Flag Set = True
            Domain = .www.linkedin.com 

            lang = "v=2&lang=en-us"
            HTTPOnly Flag Set = False
            Secure Flag Set = False
            Domain = linkedin.com 

            bcookie = "v=2&52f4f98f-4b03-4e76-8108-fa64943e23b8"
            HTTPOnly Flag Set = False
            Secure Flag Set = False
            Domain = .linkedin.com 

            lidc = "b=TGST09:g=9:u=1:i=1452442585:t=1452528985:s=AQFBgd0U4ooKN78d-Y-oP4EqatEQQgfe"
            HTTPOnly Flag Set = False
            Secure Flag Set = False
            Domain = .linkedin.com 


    #>
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0,Mandatory,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName,
        HelpMessage = 'The URL for inspection, e.g. https://www.linkedin.com')]
        [ValidateNotNullorEmpty()]
        [Alias('link')]
        [string]$url
    )


    $webrequest = Invoke-WebRequest -Uri $url -SessionVariable websession 
    $cookies = $websession.Cookies.GetCookies($url) 
    Write-Host -Object "`n"
    Write-Host 'Header Information for' $url
    Write-Host -Object ($webrequest.Headers|Out-String)
    Write-Host

    Write-Host -ForegroundColor White -Object "HTTP security Headers`nConsider adding the values in RED to improve the security of the webserver. `n"

    if($webrequest.Headers.ContainsKey('x-xss-protection')) 
    {
        Write-Host -ForegroundColor Green -Object "X-XSS-Protection Header PRESENT`n"
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'X-XSS-Protection Header MISSING'
    }
    if($webrequest.Headers.ContainsKey('Strict-Transport-Security')) 
    {
        Write-Host -ForegroundColor Green -Object 'Strict-Transport-Security Header PRESENT'
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'Strict-Transport-Security Header MISSING'
    }
    if($webrequest.Headers.ContainsKey('Content-Security-Policy')) 
    {
        Write-Host -ForegroundColor Green -Object 'Content-Security-Policy Header PRRESENT'
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'Content-Security-Policy Header MISSING'
    }
    if($webrequest.Headers.ContainsKey('X-Frame-Options')) 
    {
        Write-Host -ForegroundColor Green  -Object 'X-Frame-Options Header PRESENT'
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'X-Frame-Options Header MISSING'
    }
    if($webrequest.Headers.ContainsKey('X-Content-Type-Options')) 
    {
        Write-Host -ForegroundColor Green -Object 'X-Content-Type-Options Header PRESENT'
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'X-Content-Type-Options Header MISSING'
    }
    if($webrequest.Headers.ContainsKey('Public-Key-Pins')) 
    {
        Write-Host -ForegroundColor Green -Object 'Public-Key-Pins Header PRESENT'
    }
    else 
    {
        Write-Host -ForegroundColor Red -Object 'Public-Key-Pins Header MISSING'
    }
    Write-Host -Object "`n"


    Write-Host 'Cookies Set by' $url
    Write-Host -Object "Inspect cookies that don't have the HTTPOnly and Secure flags set."
    Write-Host -Object "`n"
    foreach ($cookie in $cookies) 
    { 
        Write-Host -Object "$($cookie.name) = $($cookie.value)"
        if ($cookie.HttpOnly -eq 'True') 
        {
            Write-Host -ForegroundColor Green 'HTTPOnly Flag Set' = "$($cookie.HttpOnly)"
        }
        else 
        {
            Write-Host -ForegroundColor Red 'HTTPOnly Flag Set' = "$($cookie.HttpOnly)"
        }
        if ($cookie.Secure -eq 'True') 
        {
            Write-Host -ForegroundColor Green 'Secure Flag Set' = "$($cookie.Secure)"
        }
        else 
        {
            Write-Host -ForegroundColor Red 'Secure Flag Set' = "$($cookie.Secure)"
        }
        Write-Host 'Domain' = "$($cookie.Domain) `n"
    }
}
