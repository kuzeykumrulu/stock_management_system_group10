"""Relational schema diagram (PK underlined, FK arrows)."""
import subprocess

T = {
    "CATEGORY": [("category_id", "PK"), ("category_name", ""), ("description", "")],
    "SUPPLIER": [("supplier_id", "PK"), ("supplier_name", ""), ("contact_name", ""), ("phone", ""), ("email", ""), ("city", "")],
    "PRODUCT": [("product_id", "PK"), ("sku", ""), ("product_name", ""), ("unit", ""), ("unit_price", ""),
                ("reorder_level", ""), ("category_id", "FK"), ("supplier_id", "FK")],
    "WAREHOUSE": [("warehouse_id", "PK"), ("warehouse_name", ""), ("city", ""), ("address", ""), ("capacity", "")],
    "EMPLOYEE": [("employee_id", "PK"), ("first_name", ""), ("last_name", ""), ("job_role", ""), ("phone", ""),
                 ("email", ""), ("hire_date", ""), ("warehouse_id", "FK")],
    "CUSTOMER": [("customer_id", "PK"), ("customer_name", ""), ("phone", ""), ("email", ""), ("city", "")],
    "INVENTORY": [("product_id", "PK,FK"), ("warehouse_id", "PK,FK"), ("quantity", ""), ("shelf_location", ""), ("last_updated", "")],
    "PURCHASE_ORDER": [("po_id", "PK"), ("order_date", ""), ("status", ""), ("supplier_id", "FK"), ("employee_id", "FK"), ("warehouse_id", "FK")],
    "PURCHASE_ORDER_ITEM": [("po_id", "PK,FK"), ("product_id", "PK,FK"), ("quantity", ""), ("unit_cost", "")],
    "SALES_ORDER": [("so_id", "PK"), ("order_date", ""), ("status", ""), ("customer_id", "FK"), ("employee_id", "FK"), ("warehouse_id", "FK")],
    "SALES_ORDER_ITEM": [("so_id", "PK,FK"), ("product_id", "PK,FK"), ("quantity", ""), ("unit_price", "")],
}
FK = [  # (table, column, ref_table, ref_col)
    ("PRODUCT", "category_id", "CATEGORY", "category_id"),
    ("PRODUCT", "supplier_id", "SUPPLIER", "supplier_id"),
    ("EMPLOYEE", "warehouse_id", "WAREHOUSE", "warehouse_id"),
    ("INVENTORY", "product_id", "PRODUCT", "product_id"),
    ("INVENTORY", "warehouse_id", "WAREHOUSE", "warehouse_id"),
    ("PURCHASE_ORDER", "supplier_id", "SUPPLIER", "supplier_id"),
    ("PURCHASE_ORDER", "employee_id", "EMPLOYEE", "employee_id"),
    ("PURCHASE_ORDER", "warehouse_id", "WAREHOUSE", "warehouse_id"),
    ("PURCHASE_ORDER_ITEM", "po_id", "PURCHASE_ORDER", "po_id"),
    ("PURCHASE_ORDER_ITEM", "product_id", "PRODUCT", "product_id"),
    ("SALES_ORDER", "customer_id", "CUSTOMER", "customer_id"),
    ("SALES_ORDER", "employee_id", "EMPLOYEE", "employee_id"),
    ("SALES_ORDER", "warehouse_id", "WAREHOUSE", "warehouse_id"),
    ("SALES_ORDER_ITEM", "so_id", "SALES_ORDER", "so_id"),
    ("SALES_ORDER_ITEM", "product_id", "PRODUCT", "product_id"),
]

L = ['digraph R {', 'graph [rankdir=LR, splines=true, nodesep=0.35, ranksep=1.1, bgcolor=white];',
     'node [shape=plaintext, fontname="Helvetica", fontsize=11];',
     'edge [color="#3A5A80", arrowhead=normal, arrowsize=0.8, penwidth=1.1];']
for t, cols in T.items():
    rows = [f'<tr><td bgcolor="#2F4F75" colspan="2"><font color="white"><b>{t}</b></font></td></tr>']
    for c, k in cols:
        name = f"<u>{c}</u>" if "PK" in k else (f"<i>{c}</i>" if "FK" in k else c)
        rows.append(f'<tr><td port="{c}" align="left" bgcolor="white">{name}</td>'
                    f'<td port="{c}_k" align="center" bgcolor="#EEF3F9"><font point-size="9">{k or " "}</font></td></tr>')
    L.append(f'"{t}" [label=<<table border="1" cellborder="1" cellspacing="0" cellpadding="4">{"".join(rows)}</table>>];')
for t, c, rt, rc in FK:
    L.append(f'"{t}":"{c}_k":e -> "{rt}":"{rc}":w;')
L.append("}")
open("logical.dot", "w").write("\n".join(L))
subprocess.run(["dot", "-Tpng", "-Gdpi=170", "logical.dot", "-o", "logical_schema.png"], check=True)
