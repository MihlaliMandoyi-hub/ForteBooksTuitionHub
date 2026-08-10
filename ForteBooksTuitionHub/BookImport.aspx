<%@ Page Title="Bulk Import Books" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookImport.aspx.cs" Inherits="ForteBooksTuitionHub.BookImport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-file-csv"></i> Bulk Import Books</h2>
    <p><a href="Books.aspx" class="btn">&laquo; Back to Catalogue</a></p>

    <div class="form-box" style="max-width:600px;">
        <p style="font-size:13px; color:#7A8699;">
            <i class="fa-solid fa-circle-info"></i> Upload a CSV file with columns <strong>Title, Author, TotalCopies</strong>
            (first row is treated as a header and skipped). Basic commas inside titles aren't supported — keep it simple.
        </p>

        <asp:Button ID="btnSample" runat="server" Text="Download Sample CSV" CssClass="btn" OnClick="btnSample_Click" CausesValidation="false" />

        <hr style="margin:20px 0; border-color:#eee;" />

        <label>CSV File</label>
        <asp:FileUpload ID="fuCsv" runat="server" style="padding:8px; border:1.5px solid #E0E6ED; border-radius:6px; width:100%;" />

        <br /><br />
        <asp:Button ID="btnImport" runat="server" Text="Import Books" CssClass="btn btn-gold" OnClick="btnImport_Click" />

        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

    <asp:Panel ID="pnlResults" runat="server" Visible="false" style="margin-top:20px;">
        <div class="dash-card" style="max-width:400px; border-top-color:#1B7A3D;">
            <h3><i class="fa-solid fa-circle-check" style="color:#1B7A3D;"></i> Import Complete</h3>
            <p><asp:Label ID="lblSummary" runat="server"></asp:Label></p>
        </div>

        <asp:Panel ID="pnlSkipped" runat="server" Visible="false" style="margin-top:15px;">
            <h3><i class="fa-solid fa-triangle-exclamation"></i> Skipped Rows</h3>
            <asp:Literal ID="litSkipped" runat="server"></asp:Literal>
        </asp:Panel>
    </asp:Panel>

</asp:Content>