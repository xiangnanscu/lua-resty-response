local encode = require "cjson.safe".encode
local ngx_header    = ngx.header
local string_format = string.format
local ngx_redirect = ngx.redirect
local ngx_print = ngx.print

local version = '1.0'

local function JsonResponse(json, status)
    return function () 
        local json, err = encode(json)
        if not json then
            return nil, err
        end
        ngx.status = status
        ngx_header.content_type = 'application/json; charset=utf-8'
        ngx_header.cache_control = 'no-store' -- ** disable cache
        return ngx_print(json)
    end
end

local function HtmlResponse(html, status)
    return function () 
        ngx.status = status
        ngx_header.content_type = 'text/html; charset=utf-8'
        return ngx_print(html)
    end
end

local function PlainResponse(text, status)
    return function () 
        ngx.status = status
        ngx_header.content_type = 'text/plain; charset=utf-8'
        return ngx_print(text)
    end
end

local function TextFileResponse(name, content)
    return function () 
        ngx_header.content_type = 'text/plain; charset=utf-8'
        ngx_header.content_disposition = string_format('attachment; filename="%s"', name)
        return ngx_print(content)
    end
end

local function HttpRedirect(url, status)
    return function () 
        return ngx_redirect(url, status)
    end
end

local function NoContentResponse()
    return function () 
        ngx.status = 204
        return true
    end
end

return {
    Json = JsonResponse, 
    Html = HtmlResponse,
    Plain = PlainResponse,
    TextFile = TextFileResponse,
    Redirect = HttpRedirect, 
    NoContent = NoContentResponse,
}