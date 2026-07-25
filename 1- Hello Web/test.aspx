<%@ Page Language="C#" %>

<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("ASP.NET is Working! Server Time: " + DateTime.Now.ToString());
    }
</script>