# business_dashboard.py
import tkinter as tk
from tkinter import messagebox, simpledialog
import pyodbc

# Database connection settings
server = '"localhost\SQLEXPRESS' ##important!! server will need to be changed to server of user's sql database server name
database = 'BusinessManagementDB'
connection_string = (
    f'DRIVER={{ODBC Driver 17 for SQL Server}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    'Trusted_Connection=yes;'
)

# Connect to SQL Server
def get_connection():
    return pyodbc.connect(connection_string)

# Display query results
def display_window(records, columns):
    window = tk.Toplevel()
    window.title("Results")

    for idx, col in enumerate(columns):
        label = tk.Label(window, text=col, font=('Arial', 10, 'bold'))
        label.grid(row=0, column=idx, padx=5, pady=5)

    for row_idx, row in enumerate(records, start=1):
        for col_idx, value in enumerate(row):
            label = tk.Label(window, text=str(value))
            label.grid(row=row_idx, column=col_idx, padx=5, pady=5)

# View functions
def view_vendors():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT VendorID, VendorName, VendorCity, VendorState FROM Vendors")
        records = cursor.fetchall()
        display_window(records, ['VendorID', 'VendorName', 'VendorCity', 'VendorState'])
        conn.close()
    except Exception as e:
        messagebox.showerror("Error", str(e))

def view_customers():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT CustomerID, FirstName, LastName, State FROM Customers")
        records = cursor.fetchall()
        display_window(records, ['CustomerID', 'FirstName', 'LastName', 'State'])
        conn.close()
    except Exception as e:
        messagebox.showerror("Error", str(e))

def view_sales():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT SaleDate, TotalAmount FROM Sales")
        records = cursor.fetchall()
        display_window(records, ['SaleDate', 'TotalAmount'])
        conn.close()
    except Exception as e:
        messagebox.showerror("Error", str(e))

def view_invoices():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT InvoiceID, VendorID, InvoiceNumber, InvoiceTotal, PaymentTotal FROM Invoices")
        records = cursor.fetchall()
        display_window(records, ['InvoiceID', 'VendorID', 'InvoiceNumber', 'InvoiceTotal', 'PaymentTotal'])
        conn.close()
    except Exception as e:
        messagebox.showerror("Error", str(e))

# Add new functions
def add_customer():
    try:
        conn = get_connection()
        cursor = conn.cursor()

        first_name = simpledialog.askstring("Input", "Enter Customer First Name:")
        last_name = simpledialog.askstring("Input", "Enter Customer Last Name:")
        state = simpledialog.askstring("Input", "Enter State (e.g., TX, CA):")
        phone = simpledialog.askstring("Input", "Enter Phone Number:")
        email = simpledialog.askstring("Input", "Enter Email Address:")
        address = simpledialog.askstring("Input", "Enter Address:")

        cursor.execute('''
            INSERT INTO Customers (FirstName, LastName, State, Phone, Email, Address)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (first_name, last_name, state, phone, email, address))

        conn.commit()
        conn.close()
        messagebox.showinfo("Success", "Customer added successfully!")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def add_sale():
    try:
        conn = get_connection()
        cursor = conn.cursor()

        customer_id = simpledialog.askinteger("Input", "Enter Customer ID:")
        vendor_id = simpledialog.askinteger("Input", "Enter Vendor ID:")
        employee_id = simpledialog.askinteger("Input", "Enter Employee ID:")
        total_amount = simpledialog.askfloat("Input", "Enter Sale Total Amount:")

        cursor.execute('''
            INSERT INTO Sales (CustomerID, VendorID, EmployeeID, SaleDate, TotalAmount)
            VALUES (?, ?, ?, GETDATE(), ?)
        ''', (customer_id, vendor_id, employee_id, total_amount))

        conn.commit()
        conn.close()
        messagebox.showinfo("Success", "Sale added successfully!")
    except Exception as e:
        messagebox.showerror("Error", str(e))

def add_invoice():
    try:
        conn = get_connection()
        cursor = conn.cursor()

        vendor_id = simpledialog.askinteger("Input", "Enter Vendor ID:")
        invoice_number = simpledialog.askstring("Input", "Enter Invoice Number:")
        invoice_total = simpledialog.askfloat("Input", "Enter Invoice Total Amount:")
        terms_id = 1  # Default to Net 30 for simplicity

        cursor.execute('''
            INSERT INTO Invoices (VendorID, InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal, TermsID, InvoiceDueDate, PaymentDate)
            VALUES (?, ?, GETDATE(), ?, 0, 0, ?, DATEADD(day, 30, GETDATE()), NULL)
        ''', (vendor_id, invoice_number, invoice_total, terms_id))

        conn.commit()
        conn.close()
        messagebox.showinfo("Success", "Invoice added successfully!")
    except Exception as e:
        messagebox.showerror("Error", str(e))

# GUI setup
root = tk.Tk()
root.title("Business Management Dashboard")
root.geometry("450x400")

# Buttons
btn_view_vendors = tk.Button(root, text="View Vendors", width=30, command=view_vendors)
btn_view_customers = tk.Button(root, text="View Customers", width=30, command=view_customers)
btn_view_sales = tk.Button(root, text="View Sales", width=30, command=view_sales)
btn_view_invoices = tk.Button(root, text="View Invoices", width=30, command=view_invoices)
btn_add_customer = tk.Button(root, text="Add New Customer", width=30, command=add_customer)
btn_add_sale = tk.Button(root, text="Add New Sale", width=30, command=add_sale)
btn_add_invoice = tk.Button(root, text="Add New Invoice", width=30, command=add_invoice)

# Pack buttons
btn_view_vendors.pack(pady=5)
btn_view_customers.pack(pady=5)
btn_view_sales.pack(pady=5)
btn_view_invoices.pack(pady=5)
btn_add_customer.pack(pady=5)
btn_add_sale.pack(pady=5)
btn_add_invoice.pack(pady=5)

root.mainloop()
