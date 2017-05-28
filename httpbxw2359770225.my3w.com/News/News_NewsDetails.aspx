<%@ Page Language="C#" AutoEventWireup="true" CodeFile="News_NewsDetails.aspx.cs" Inherits="News_News_NewsDetails" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>分页</title>
    <link rel="stylesheet" href="../CSS/pages.css" type="text/css">
    <link rel="stylesheet" href="../CSS/news.css" type="text/css">
    <script src="../jQuery/jquery-2.2.1.min.js"></script>
    <script src="../js/pages.js"></script>
    <script src="../js/newsDetail.js"></script>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="black" name="apple-mobile-web-app-status-bar-style">
    <meta content="telephone=no" name="format-detection">
    <meta content="email=no" name="format-detection" >
    <meta http-equiv="Cache-Control" content="no-siteapp" />
</head>
<body onselectstart="return false">
    <header>
        <img src="../img/logo.png" alt="logo" id="logo"/>
        <div>
            <form action="post" id="search">
                <input type="text" placeholder="搜索..."/>
            </form>
            <nav>
                <a id="link_home" href="../Index.aspx" class="link_now">首页</a>
                <a id="link_system" href="#">系统</a>
                <a id="link_data" href="#">资料</a>
                <a id="link_open" href="#">开放实验</a>

            </nav>
        </div>
    </header>
    <section id="main_container">
    <article id="main">
        <form id="form1" runat="server" >
            <asp:ScriptManager ID="ScriptManager1" runat="server">
                <Services>
                    <asp:ServiceReference Path="../WebService_News.asmx" />
                </Services>
            </asp:ScriptManager>
        </form>
        <nav>
            <a href="../Index.aspx">主页</a>
            <a href="News_NewsDetails.aspx">新闻公告</a>
        </nav>
        <div class="content">
            <h1 class="title">这是标题</h1>
            <div class="contentInfo">
                <span>发布人: Cmd</span>
                <time>发布时间: 2015-05-05</time>
            </div>
        </div>
        <div class="contentFooter">
            <time>发布时间: 2015-05-05</time>
        </div>
    </article>
    </section>
    <footer>
        <span id="copyright">&copy;中山大学珠海校区化学实验室信息管理平台 by Cmd</span>
        <div id="footer_others">
            <a href="#">About Us</a>
            <a href="javascript:void(0)">联系我们<div id="connect_img"></div></a>
            <a target="_self" href="http://wpa.qq.com/msgrd?v=3&uin=784270942&site=qq&menu=yes">意见反馈</a>
        </div>
    </footer>
</body>
</html>
