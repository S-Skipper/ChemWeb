using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using News_Information.BLL;
public partial class News_News_new : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        
        name.Text = Session.Contents["name"].ToString();
       
    }
    
   
    protected void submit_Click(object sender, EventArgs e)
    {
        NewsInformation login_Newinformation = new NewsInformation();
        Login_News loginNews = new Login_News();
        loginNews.Content_1 = content1.InnerText;
        loginNews.DateTime = DateTime.Now;
        loginNews.Title = titles.Text.Trim();
        loginNews.Member_Name = name.Text;
        loginNews.ArticleID = -1;
        if (type.Text == "新闻")
            loginNews.type = 1;
        else
            loginNews.type = 2;
        login_Newinformation.Add_UpdateNews(loginNews);
        Response.Redirect("News_Home.aspx");
    }
    protected void see_Click(object sender, EventArgs e)
    {
       
        lable_see.Text = content1.InnerText;
    }
}