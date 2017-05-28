<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/News.master" AutoEventWireup="true" CodeFile="News_new.aspx.cs" Inherits="News_News_new" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="../kindeditor/themes/default/default.css" />
	<link rel="stylesheet" href="../kindeditor/plugins/code/prettify.css" />
	<script charset="utf-8" src="../kindeditor/kindeditor-all-min.js"></script>
	<script charset="utf-8" src="../kindeditor/lang/zh-CN.js"></script>
	<script charset="utf-8" src="../kindeditor/plugins/code/prettify.js"></script>
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
	                    K('form[name=example]')[0].submit();
	                });
	                K.ctrl(self.edit.doc, 13, function () {
	                    self.sync();
	                    K('form[name=example]')[0].submit();
	                });
	            }
	        });
	        prettyPrint();
	    });
	</script>
    <title>新建新闻</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <nav>
        <a href="News_index.aspx">新闻中心</a>
        <a href="News_Home.aspx">新闻管理</a>
        <a href="new.aspx">新建新闻</a>
        </nav>
    <form id="example" name="example" runat ="server">       
            <label>标题:</label>
            <asp:TextBox ID="titles" runat="server"></asp:TextBox>
            <br />
             <label>编辑人员:</label>
            <asp:TextBox ID="name" runat="server" ReadOnly="true"></asp:TextBox>
            <br />
            <label>类型:</label>
            <asp:DropDownList ID="type" runat="server">
            <asp:ListItem>新闻</asp:ListItem>
            <asp:ListItem>公告</asp:ListItem>
            </asp:DropDownList>
            <br />
            <label>内容:</label>
            <br />
            <textarea id="content1" cols="100" rows="8" style="width:700px;height:200px;visibility:hidden;" runat="server"></textarea>
            <br />
            <asp:Button  ID ="see" runat="server" Text="预览" OnClick="see_Click"  />
            <asp:Button ID="submit" runat="server" Text="上传" OnClick="submit_Click" />
            <br />
            <asp:Label ID="lable_see" runat="server" Text=""></asp:Label>

    </form>
</asp:Content>

