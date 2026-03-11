<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Car</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/templatemo-customer.css">
    <style>
        .owner-card{max-width:900px;margin:0 auto;background:#fff;border:1px solid #e9eef4;border-radius:16px;padding:18px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .grid{display:grid;grid-template-columns:repeat(2,minmax(240px,1fr));gap:12px}
        .field label{display:block;font-weight:600;margin-bottom:6px;color:#334155}
        .field input,.field textarea,.field select{width:100%;padding:10px;border:1px solid #dbe4ee;border-radius:10px}
        .field textarea{min-height:120px}
        .btn-owner{background:#22b3c1;color:#fff;border:none;padding:10px 16px;border-radius:999px;font-weight:600;cursor:pointer}
    </style>
</head>
<body>


<div class="owner-card">
    <h2>Create Car</h2>
    <form action="<%= request.getContextPath() %>/owner" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="create"/>
        <div class="grid">
            <div class="field"><label>Name</label><input type="text" name="name" required/></div>
            <div class="field"><label>License Plate</label><input type="text" name="licensePlate" required/></div>
            <div class="field"><label>Brand</label><input type="text" name="brand"/></div>
            <div class="field"><label>Model</label><input type="text" name="model"/></div>
            <div class="field"><label>Year</label><input type="number" name="year" min="1990" max="2100"/></div>
            <div class="field"><label>Color</label><input type="text" name="color"/></div>
            <div class="field"><label>Price/Day</label><input type="number" name="pricePerDay" min="0"/></div>
            <div class="field"><label>Status</label><select name="status"><option value="AVAILABLE">AVAILABLE</option><option value="RENTED">RENTED</option><option value="MAINTENANCE">MAINTENANCE</option></select></div>
            <div class="field" style="grid-column:1/-1"><label>Description</label><textarea name="description"></textarea></div>
            <div class="field" style="grid-column:1/-1"><label>Cover Image</label><input type="file" name="imageFile" accept="image/*"/></div>
        </div>
        <div style="margin-top:14px;display:flex;gap:8px">
            <button class="btn-owner" type="submit">Save</button>
            <a class="btn-owner" style="background:#64748b" href="<%= request.getContextPath() %>/owner">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>
