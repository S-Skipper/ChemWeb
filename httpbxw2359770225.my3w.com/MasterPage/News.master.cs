using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage_News : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
      
        //权限管理
        string rank;
        rank = Login_Or_Rank("rank_control");
        if (rank == "没有权限")
        {
            
            LOGIN.Visible = false;
        }
        rank = Login_Or_Rank("rank_drug");
        if (rank == "没有权限")
        {
            DRUG.Visible = false;
        }

        rank = Login_Or_Rank("rank_news");
        
        if (rank == "管理权限")
        {

        }
        else
            Response.Redirect("../Login/Login_Wrong.aspx");
      
    }
    /// <summary>
    /// 验证登陆信息及权限要求 为空则表示判断用户是否登陆 其他值为权限名 返回权限值
    /// </summary>
    /// <param 权限="？">为空代表只判断是否已经登陆 登陆返回1 有值话返回值对应的数字</param>
    public string Login_Or_Rank(string rank_Name)
    {
        if (rank_Name != "" && Session.Contents["ID"] != null)
            return Session.Contents[rank_Name].ToString();
        if (Session.Contents["ID"] != null)
            return "登录状态";
        else
            return "未登录状态";

    }
}
