<%  
response.expires=-1

    '获得来自 URL 的 q 参数
    Dim ID = Request.Form("ID")
    Response.Write(ID)
    %>

