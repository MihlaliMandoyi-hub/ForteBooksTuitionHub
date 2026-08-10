<%@ Page Title="Outstanding Balances" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OutstandingBalances.aspx.cs" Inherits="ForteBooksTuitionHub.OutstandingBalances" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-scale-balanced"></i> Outstanding Balances</h2>
    <div class="no-print" style="margin-bottom:15px;">
        <a href="Payments.aspx" class="btn">&laquo; Back to Payments</a>
        <asp:Button ID="btnPrint" runat="server" Text="Print This Report" CssClass="btn btn-gold" OnClientClick="window.print(); return false;" />
    </div>

    <asp:Label ID="lblMessage" runat="server" ForeColor="Green" Font-Bold="true" style="display:block; margin-bottom:10px;"></asp:Label>

    <asp:GridView ID="gvBalances" runat="server" AutoGenerateColumns="false" CssClass="grid" GridLines="None">
        <Columns>
            <asp:BoundField DataField="FullName" HeaderText="Student" />
            <asp:BoundField DataField="TotalCharges" HeaderText="Total Charges (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="TotalPaid" HeaderText="Total Paid (R)" DataFormatString="{0:N2}" />
            <asp:BoundField DataField="Balance" HeaderText="Balance (R)" DataFormatString="{0:N2}" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <a href='RefundStudent.aspx?studentId=<%# Eval("StudentId") %>' class="btn btn-gold no-print">
                        <i class="fa-solid fa-hand-holding-dollar"></i> Refund
                    </a>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            No students found.
        </EmptyDataTemplate>
    </asp:GridView>

    <p style="font-size:12px; color:#7A8699; margin-top:15px;" class="no-print">
        <i class="fa-solid fa-circle-info"></i> A negative balance means the student has overpaid and the centre owes them credit.
        Use the <strong>Refund</strong> button to pay that credit back to the student.
    </p>

</asp:Content>