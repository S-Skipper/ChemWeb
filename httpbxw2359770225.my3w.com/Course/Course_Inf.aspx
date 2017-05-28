<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Course.master" AutoEventWireup="true" CodeFile="Course_Inf.aspx.cs" Inherits="Course_Course_Inf" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>实验信息查询</title>
     <script type="text/javascript">
         function GetCourse() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("course").value;
             WebService_Course.GetCoures(ID, PW, a, GetValue1_1);

         }
         function GetCourseDetail() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("course").value;
             WebService_Course.GetCourseExper(ID, PW, a, GetValue3_2);
             WebService_Course.GetCoures(ID, PW, a, GetValue1_2);
             WebService_Course.GetCourse_AllDrug(ID, PW, a, GetValue4_3);
         }
         function Insert_Update() {

             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("TextArea1_2").value;
             c = document.getElementById("TextArea3_2").value;
             course1 = document.getElementById("course1").value;
             WebService_Course.Course_Insert_Update(ID, PW, a, c, course1, GetValue1_1);
         }
         function Delete() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("course").value;
             WebService_Course.Course_Delete(ID, PW, a, GetValue1_1)
         }
         function GetCoursePrivate() {
             //设置参数，并帮定脚本事件
             var ID = "13354442"; //"<%=GetSession("ID")%>";
             var PW = "13354442"; //"<%=GetSession("PW")%>";
             WebService_Course.Course_LoginByID(ID, PW, GetValue41);

         }
         function GetCourseGetLogin() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("name").value;
             WebService_Course.Course_LoginByName(ID, PW, a, GetValue43);

         }
         function Insert_Update_Login() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             a = document.getElementById("TextArea43").value;
             b = document.getElementById("name").value;
             WebService_Course.Course_LoginInsert_Update(ID, PW, a, b, GetValue43);

         }
         function Course_Check() {
             //判断某个一般用户是否有添加用户的权限
             //b 为输入的课程的名字
                var ID = "13354442"; //"<%=GetSession("ID")%>";
              var PW = "13354442"; //"<%=GetSession("PW")%>";
              b = document.getElementById("name").value;
              WebService_Course.Course_Check(ID, PW, b, GetValue43);

          }

         function GetValue1_1(result) {
             //显示返回的值

             document.getElementById("TextArea1_1").value = result;
         }
         function GetValue1_2(result) {
             //显示返回的值

             document.getElementById("TextArea1_2").value = result;
         }
         function GetValue2_1(result) {
             //显示返回的值

             document.getElementById("TextArea2_1").value = result;
         }
         function GetValue2_2(result) {
             //显示返回的值

             document.getElementById("TextArea2_2").value = result;
         }
         function GetValue3_1(result) {
             //显示返回的值

             document.getElementById("TextArea3_1").value = result;
         }
         function GetValue3_2(result) {
             //显示返回的值

             document.getElementById("TextArea3_2").value = result;
         }
         function GetValue4_1(result) {
             //显示返回的值

             document.getElementById("TextArea4_1").value = result;
         }
         function GetValue4_2(result) {
             //显示返回的值

             document.getElementById("TextArea4_2").value = result;
         }
         function GetValue4_3(result) {
             //显示返回的值

             document.getElementById("TextArea4_3").value = result;
         }
         function GetValue41(result) {
             //显示返回的值

             document.getElementById("TextArea41").value = result;
         }
         function GetValue42(result) {
             //显示返回的值

             document.getElementById("TextArea42").value = result;
         }
         function GetValue43(result) {
             //显示返回的值

             document.getElementById("TextArea43").value = result;
         }
         function GetExperience() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
                      var PW = "1111"; //"<%=GetSession("PW")%>";
                      a = document.getElementById("experment").value;
                      WebService_Exper.GetExperience(ID, PW, a, GetValue3_1);

                  }
         function GetUser() {
             //设置参数，并帮定脚本事件
             var ID = "1111"; //"<%=GetSession("ID")%>";
             var PW = "1111"; //"<%=GetSession("PW")%>";
             WebService_login.GetUserByRank(ID, PW, "rank_course", "一般权限", GetValue42);

         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
          <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
       
         <Services>
                    <asp:ServiceReference Path="../Webservice_Course.asmx" />
                    <asp:ServiceReference Path="../Webservice_Exper.asmx" />
                    <asp:ServiceReference Path="../WebService_login.asmx" />
          </Services>
    </asp:ScriptManagerProxy> 
 <br />  
         课程名称查询：<input type="text" id="course" />
            <input id ="b2" type="button" value="搜索课程" onclick="GetCourse()" /> 
            <br />
  
                课程基本信息<textarea id="TextArea1_1" cols="20" rows="5" name="S1"></textarea>
                    
                课程修改信息填写：<textarea id="TextArea1_2" cols="20" rows="5" name="S1"></textarea>
          <br />
                试剂名称输入：<input type="text" id="experment" /> 
                <input id ="b8" type="button" value="搜索实验" onclick="GetExperience()" /> 
               
                     <br />
                    显示实验列表：<textarea id="TextArea3_1" cols="20" rows="5" name="S1"></textarea>
                    
                    实验情况显示填写：<textarea id="TextArea3_2" cols="20" rows="5" name="S1"></textarea>
                  <br />
                  
                 
                  课程转换为药品量：<textarea id="TextArea4_3" cols="20" rows="5" name="S2"></textarea>
                  <br />
            <br />

             <input id ="b3" type="button" value="实验详细资料" onclick="GetCourseDetail()" /> 
         <br />
           此按钮对管理员有效其他隐藏 或者是打开个人管理实验界面后一般权限用户可用
               <input type="text" id="course1" /> <input id ="b4" type="button" value="添加或更新" onclick="Insert_Update()" /> 
     <br />
            此按钮对管理员有效其他隐藏 
             <input id ="b5" type="button" value="删除" onclick="Delete()" /> 
    
     <br />
           此按钮对一般权限用户有效其他隐藏
              <input id ="b454" type="button" value="查看个人管理课程" onclick="GetCoursePrivate()" /> 
     可管理界面显示：<textarea id="TextArea41" cols="20" rows="5" name="S1"></textarea>
     <br />
     此按钮对管理员有效其他隐藏 用于查看某个实验对应的管理人员 或者是打开个人管理实验界面后一般权限用户可用
       需要管理的实验名输入：<input type="text" id="name" /> 
    <input id ="b555" type="button" value="人员管理" onclick="GetCourseGetLogin()" /> 
    <br />
    <input id ="b525" type="button" value="判断是否有人员管理的权限" onclick="Course_Check()" /> 
    <br />

    GetUser
     <input id ="b553" type="button" value="人员查看" onclick="GetUser()" /> 
     人员搜索：<textarea id="TextArea42" cols="20" rows="5" name="S1"></textarea>
    可管理人员界面显示：<textarea id="TextArea43" cols="20" rows="5" name="S1"></textarea>
     <br />
           需要输入 需要管理的课程名 以及可管理人员页面后点击按钮
             <input id ="b55" type="button" value="人员管理提交" onclick="Insert_Update_Login()" /> 
</asp:Content>

