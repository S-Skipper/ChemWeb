<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/News.master" AutoEventWireup="true" CodeFile="News_Edit.aspx.cs" Inherits="News_News_Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link rel="stylesheet" href="../kindeditor/themes/default/default.css" />
	<link rel="stylesheet" href="../kindeditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="../kindeditor/kindeditor-all-min.js"></script>
	<script charset="utf-8" src="../kindeditor/lang/zh-CN.js"></script>
	<script charset="utf-8" src="../kindeditor/plugins/code/prettify.js"></script>
	  <title>新闻增添或修改</title>
    <script type="text/javascript">
        var id = "<%=GetSession("ID")%>";
        var pw = "<%=GetSession("PW")%>";
        var manager = "<%=GetSession("rank_news")%>";
       
    </script>
    <script>
	    KindEditor.ready(function (K) {
	        var editor1 = K.create('#ContentPlaceHolder1_content1', {
	            cssPath: '../kindeditor/plugins/code/prettify.css',
	            uploadJson: '../kindeditor/asp.net/upload_json.ashx',
	            fileManagerJson: '../kindeditor/asp.net/file_manager_json.ashx',
	            allowFileManager: true,
	            afterCreate: function () {
	                var self = this;
	                K.ctrl(document, 13, function () {
	                    self.sync();
	                    K('form[name=form2]')[0].submit();
	                });
	                K.ctrl(self.edit.doc, 13, function () {
	                    self.sync();
	                    K('form[name=form2]')[0].submit();
	                });
	            }
	        });
	        prettyPrint();
	    });
	</script>
        <script type="text/javascript">
            function GetNewsById() {
                //给id  返回给你一个详细的新闻 
                id1 = document.getElementById("id1").value;
                WebService_News.GetNewsDetail(id1, GetValue);
            }
            function InsertOrUpdate() {
                //更新 示例 id为更新新闻名 [{"ArticleID":"1","Title":"错不在没保障","Content_1":"错不在没保障","DateTime":"2016/9/23 0:00:07","Hits":"0","Member_Name":"sss","type":"1","infor":"1"}]
                //将id改成-1 则为插入 
                inform = document.getElementById("TextArea1").value;
                WebService_News.Add_UpdateNews(id, pw, inform, GetValue);
            }
            function GetValue(result) {
                //显示返回的值

                document.getElementById("TextArea1").value = result;
            }

    </script>
    <title>新建新闻</title>
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
        <a href="News_Edit.aspx">新增或修改新闻</a>
        </nav>    

    状态：<textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea><br />
     
    以下这些之后全部用json格式返回给我 然后那个编辑框的id为 #ContentPlaceHolder1_content1<br />
      id:<input type="text" id="id1" />(新建话填-1 修改话填修改的id 这个输入框是隐藏的 )<br />
     标题：<input type="text" id="type1" /><br />
     编辑人员：<input type="text" id="type2" />(从session获取 )<br />
     类型：<input type="text" id="type3" />(获取新闻返回1  公告返回2 )><br />
     内容：<textarea id="content1" cols="100" rows="8" style="width:700px;height:200px;visibility:hidden;" runat="server"></textarea>

   <br />
     载入需要在id栏输入id号<br />
     载入：<input id ="b6" type="button" value="载入" onclick="GetNewsById()" /> 载入需要在
     提交：<input id ="b7" type="button" value="提交" onclick="InsertOrUpdate()" />
    预览：
          <input id ="b8" type="button" value="删除"  />
</asp:Content>

