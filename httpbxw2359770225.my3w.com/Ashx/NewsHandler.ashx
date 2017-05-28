<%@ WebHandler Language="C#" Class="NewsHandler" %>

using System;
using System.Web;
using System.Data;
using News_Information.BLL;
using Login_Rank_Information.BLL;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
public class NewsHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/json";
        context.Response.AddHeader("Access-Control-Allow-Origin", "*");
        context.Response.AddHeader("Access-Control-Allow-Methods", "POST");
        context.Response.AddHeader("Access-Control-Max-Age", "1000");
        string infor = "[" + context.Request["json"] + "]";
       
        
        JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
        string Type = ja[0]["type"].ToString();

        if (Type.Equals("GetNews"))
        {
            //context.Response.Write(infor);
            string Title = ja[0]["title"].ToString();

            context.Response.Write(GetNews(Title));
        }
        //获得新闻信息
         else if (Type.Equals("GetNewsLate"))
        {
             string num = ja[0]["num"].ToString();
             string news_type = ja[0]["news_type"].ToString();

             context.Response.Write(GetNewsLate(num,news_type));
        }
        //获得新闻信息
        else if (Type.Equals("GetNewsFromTo"))
        {
            string from = ja[0]["from"].ToString();
            string to = ja[0]["to"].ToString();
            string title = ja[0]["Title"].ToString();
            context.Response.Write(GetNewsFromTo(from, to, title));
        }
        else if (Type.Equals("DelNews"))
        {
            string ID = ja[0]["id"].ToString();
            string PW = ja[0]["pw"].ToString();
            string ArticleID = ja[0]["ArticleID"].ToString();
            context.Response.Write(DelNews(ID, PW, ArticleID));
        }
        else if (Type.Equals("GetNewsDetail"))
        {
            string ArticleID = ja[0]["ArticleID"].ToString();


            context.Response.Write(GetNewsDetail(ArticleID));
        }
        else if (Type.Equals("Add_UpdateNews"))
        {
            string ID = ja[0]["id"].ToString();
            string PW = ja[0]["pw"].ToString();

            context.Response.Write(Add_UpdateNews(ID, PW,infor));
        }
            
        else
        {
            context.Response.Write(Type);
            
        }

    }




    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    
    
    public string GetNews(string Title)
    {
        NewsInformation newsInformation = new NewsInformation();

        return dsToJson(newsInformation.LoadData(Title));
    }

    public string GetNewsFromTo(string from, string to, string Title)
    {
        NewsInformation newsInformation = new NewsInformation();

        return dsToJson(newsInformation.LoadDataFromTo(from, to, Title));
    }
    
    //根据新闻类型获得最新的n新闻
    public string GetNewsLate(string num,string type)
    {
        NewsInformation newsInformation = new NewsInformation();
        if (type != "1" && type != "2")
        {
            type = "1";
        }
        return dsToJson(newsInformation.GetLateNews(num,type));
    }
    
    //删除新闻
    public string DelNews(string ID, string PW, string id)
    {
        NewsInformation newsInformation = new NewsInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_news == "管理权限")
            {
                if (newsInformation.DeleteNews_Detail(id))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"10\"}";//"失败，删除信息不存在"
                }
            }
            else
            {
                return "{\"error\":\"02\"}";//无权限
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }
    }
    //获得id对应新闻的具体情况
    public string GetNewsDetail(string num)
    {
        NewsInformation newsInformation = new NewsInformation();

        DataSet ds = newsInformation.GetNews_Detail(num);
        if (ds.Tables[0].Rows.Count == 0)
        {
            return "{\"error\":\"10\"}";//新闻不存在
        }
        
        Add_Hits(num);

        return dsToJson(ds);
    }
    //添加新闻
    public string Add_UpdateNews(string ID, string PW, string infor)
    {
        NewsInformation newsInformation = new NewsInformation();
        LoginRankInformation login_getinformation = new LoginRankInformation();
        Login_News login_News = new Login_News();
        login_rank login_rank1 = login_getinformation.LoadData(ID);
        if (PW.Equals(login_rank1.PW) || login_getinformation.Token(ID, PW))
        {
            if (login_rank1.rank_news == "管理权限")
            {
                JArray ja = (JArray)JsonConvert.DeserializeObject(infor);
                login_News.ArticleID = (Int32)ja[0]["ArticleID"];
                //判断是否需要读取其他量

                login_News.Title = ja[0]["Title"].ToString();
                login_News.Content_1 = ja[0]["Content_1"].ToString();
                login_News.Member_Name = ja[0]["Member_Name"].ToString();
                login_News.infor = ja[0]["infor"].ToString();
                login_News.type = (Int32)ja[0]["news_type"];
                login_News.Hits = (Int32)ja[0]["Hits"];
                login_News.DateTime = DateTime.Now;

                if (newsInformation.Add_UpdateNews(login_News))
                {
                    return "{\"error\":\"0\"}";//成功
                }
                else
                {
                    return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
                }
            }
            else
            {
                return "{\"error\":\"02\"}";//无权限
            }

        }
        else
        {
            return "{\"error\":\"01\"}";//失败 未登录
        }
    }
    //增加点击量
    public string Add_Hits(string ArticleID)
    {
        NewsInformation newsInformation = new NewsInformation();
        if (newsInformation.Add_Hits(ArticleID))
        {
            return "{\"error\":\"0\"}";//成功
        }
        else
        {
            return "{\"error\":\"09\"}";//"失败，未知原因操作失败，请重试或联系管理员"
        }
    }
    
    
    
    
    
    private string dsToJson(DataSet ds)
    {
        string json = "{\"error\":\"0\",\"data\":[";
        try
        {
            if (ds.Tables.Count == 0)
                throw new Exception("DataSet中Tables为0");

            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                json += "{";

                for (int k = 0; k < ds.Tables[0].Columns.Count; k++)
                {
                    json += "\"" + ds.Tables[0].Columns[k].ColumnName.ToString().Trim() + "\"" + ":\"" + ds.Tables[0].Rows[i][k].ToString().Trim() + "\"";

                    if (k < ds.Tables[0].Columns.Count - 1)
                    {
                        json += ",";
                    }
                }

                json += "}";
                if (i < ds.Tables[0].Rows.Count - 1)
                {
                    json += ",";
                }


            }

            json += "]";

            json += "}";

        }

        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
        return json;
    }  
}