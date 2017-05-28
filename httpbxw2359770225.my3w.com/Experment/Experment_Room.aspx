<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Experment.master" AutoEventWireup="true" CodeFile="Experment_Room.aspx.cs" Inherits="Experment_Experment_Room" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
        <title>试剂信息查询</title>
     <script type="text/javascript">
         function GetRoom() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
            var PW = "1111"; //"<%=GetSession("PW")%>";
            WebService_Exper.GetRoom(ID, PW, GetValue);
        }
         function GetRoomExper() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("room_name1").value;
             WebService_Exper.GetRoom_Exper(ID, PW, a, GetValue);
         }
         function Insert_Update() {

             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("TextArea1").value;
             room_name = document.getElementById("room_name").value;
             WebService_Exper.Room_Insert_Update(ID, PW, a, room_name, GetValue);
         }
         function Delete() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("room_name").value;
             WebService_Exper.Room_Delete(ID, PW, a, GetValue)
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
                    <asp:ServiceReference Path="../Webservice_Exper.asmx" />
                    
          </Services>
    </asp:ScriptManagerProxy> 

                    <br />
  
                    实验室教室信息<textarea id="TextArea1" cols="20" rows="5" name="S1"></textarea>

        <br />
                <br />

                    <input id ="b3" type="button" value="教室资料查询" onclick="GetRoom()" /> 
                <br />
                    教室对应实验查询：<input type="text" id="room_name1" />
                <input id ="b2" type="button" value="搜索教室对应实验" onclick="GetRoomExper()" /> 
        <br />
                    <input type="text" id="room_name" /> <input id ="b4" type="button" value="添加或更新" onclick="Insert_Update()" /> 
            
                    <input id ="b5" type="button" value="删除" onclick="Delete()" /> 
</asp:Content>

