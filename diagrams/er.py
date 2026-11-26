"""Generate Chen-notation ER diagram for the Stock Management System."""
import subprocess, sys

entities = {
    "CATEGORY": ["<u>category_id</u>", "category_name", "description"],
    "SUPPLIER": ["<u>supplier_id</u>", "supplier_name", "contact_name", "phone", "email", "city"],
    "PRODUCT": ["<u>product_id</u>", "sku", "product_name", "unit", "unit_price", "reorder_level"],
    "WAREHOUSE": ["<u>warehouse_id</u>", "warehouse_name", "city", "address", "capacity"],
    "EMPLOYEE": ["<u>employee_id</u>", "Name", "job_role", "phone", "email", "hire_date"],
    "CUSTOMER": ["<u>customer_id</u>", "customer_name", "phone", "email", "city"],
    "PURCHASE_ORDER": ["<u>po_id</u>", "order_date", "status"],
    "SALES_ORDER": ["<u>so_id</u>", "order_date", "status"],
}
composite = {("EMPLOYEE", "Name"): ["first_name", "last_name"]}

# (name, entity1, card1, total1, entity2, card2, total2, attributes)
rels = [
    ("BELONGS_TO", "PRODUCT", "N", True, "CATEGORY", "1", False, []),
    ("SUPPLIES", "SUPPLIER", "1", False, "PRODUCT", "N", True, []),
    ("STORED_IN", "PRODUCT", "M", False, "WAREHOUSE", "N", False, ["quantity", "shelf_location", "last_updated"]),
    ("WORKS_AT", "EMPLOYEE", "N", True, "WAREHOUSE", "1", False, []),
    ("PLACES", "CUSTOMER", "1", False, "SALES_ORDER", "N", True, []),
    ("HANDLES", "EMPLOYEE", "1", False, "SALES_ORDER", "N", True, []),
    ("SHIPS_FROM", "SALES_ORDER", "N", True, "WAREHOUSE", "1", False, []),
    ("SO_CONTAINS", "SALES_ORDER", "M", True, "PRODUCT", "N", False, ["quantity", "unit_price"]),
    ("RECEIVES", "SUPPLIER", "1", False, "PURCHASE_ORDER", "N", True, []),
    ("CREATES", "EMPLOYEE", "1", False, "PURCHASE_ORDER", "N", True, []),
    ("DELIVERED_TO", "PURCHASE_ORDER", "N", True, "WAREHOUSE", "1", False, []),
    ("PO_CONTAINS", "PURCHASE_ORDER", "M", True, "PRODUCT", "N", False, ["quantity", "unit_cost"]),
]

L = ['graph ER {',
     'graph [layout=neato, overlap=false, splines=true, sep="+12", esep="+6", '
     'fontname="Times New Roman", outputorder=edgesfirst, bgcolor=white];',
     'node [fontname="Times New Roman", fontsize=12];',
     'edge [fontname="Times New Roman", fontsize=13, len=1.2];']

for e, attrs in entities.items():
    L.append(f'"{e}" [shape=box, style="filled,bold", fillcolor="#DCE8F5", penwidth=1.6, fontsize=14, label=<<b>{e}</b>>];')
    for a in attrs:
        plain = a.replace("<u>", "").replace("</u>", "")
        nid = f"{e}.{plain}"
        L.append(f'"{nid}" [shape=ellipse, style=filled, fillcolor="#FFFFFF", label=<{a}>];')
        L.append(f'"{e}" -- "{nid}" [len=0.9];')
        for sub in composite.get((e, plain), []):
            sid = f"{nid}.{sub}"
            L.append(f'"{sid}" [shape=ellipse, label="{sub}"];')
            L.append(f'"{nid}" -- "{sid}" [len=0.8];')

for name, e1, c1, t1, e2, c2, t2, attrs in rels:
    rid = f"R_{name}"
    L.append(f'"{rid}" [shape=diamond, style=filled, fillcolor="#FBE7C6", label=<<b>{name}</b>>, fontsize=11];')
    for e, c, t in ((e1, c1, t1), (e2, c2, t2)):
        style = 'color="black:invis:black", ' if t else ''
        L.append(f'"{rid}" -- "{e}" [{style}label=" {c} ", len=1.6];')
    for a in attrs:
        aid = f"{rid}.{a}"
        L.append(f'"{aid}" [shape=ellipse, label="{a}"];')
        L.append(f'"{rid}" -- "{aid}" [len=0.8];')

L.append("}")
open("er.dot", "w").write("\n".join(L))
subprocess.run(["dot", "-Kneato", "-Tpng", "-Gdpi=170", "er.dot", "-o", "er_diagram.png"], check=True)
