<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/News.master" AutoEventWireup="true" CodeFile="News_Home.aspx.cs" Inherits="News_News_Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>新闻中心</title>
    <script type="text/javascript">
        var id = "<%=GetSession("ID")%>";
        var pw = "<%=GetSession("PW")%>";
        var manager = "<%=GetSession("rank_news")%>";
       
    </script>

    <script type="text/javascript">
        function GetAll() {
            //给id  返回给你一个详细的个人信息
            type1 = document.getElementById("type").value;
            WebService_News.GetNews(type1, GetValue);
        }
        function Del() {
            //给id  返回给你一个详细的个人信息
            NewsId = document.getElementById("del").value;
            WebService_News.DelNews(id,pw,NewsId,GetValue);
        }
        function Add_Hits() {
            //给id 点击数+1 把这个放到 News_NewsDetails.aspx 的js里让他每次页面打开就执行一遍 此页面不需要
            NewsId = document.getElementById("del").value;
            WebService_News.Add_Hits(NewsId, GetValue);
        }
        function GetValue(result) {
            //显示返回的值

            document.getElementById("TextArea1").value = result;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
             <asp:ServiceReference Path="../WebService_News.asmx" />
        </Services>
    </asp:ScriptManagerProxy>      
    <nav>
        <a href="News_index.aspx">新闻中心</a>
        <a href="News_Home.aspx">新闻管理</a>
        </nav>
    获得新闻或公告：<textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea><br />
    type：<input type="text" id="type" />(获取新闻返回1  公告返回2 )
    <br />
          <input id ="b6" type="button" value="获得信息" onclick="GetAll()" />
    <br />


    修改链接在这里
     <a href="News_Edit.aspx">修改</a>（要传入点击的新闻id ）
    <br />

    <a href="News_NewsDetails.aspx?ID=15">预览</a>（要传入点击的新闻id ）
     del：<input type="text" id="del" />(输入id 删除新闻 )
    <br />
          <input id ="b7" type="button" value="删除" onclick="Del()" />

     
    <br />
          增加点击数（需要给id）<input id ="b7" type="button" value="增加点击数" onclick="Add_Hits()" />

</asp:Content>

