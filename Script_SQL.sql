-- Membuat tabel 
-- Tabel penjualan
CREATE TABLE penjualan (
  id_distributor VARCHAR(45) NOT NULL,
  id_cabang VARCHAR(45) NULL,
  id_invoice VARCHAR(45) NOT NULL,
  tanggal DATE NULL,
  id_customer VARCHAR(45) NULL,
  id_barang VARCHAR(45) NULL,
  jumlah INT NULL,
  unit VARCHAR(45) NULL,
  harga DECIMAL(45) NULL,
  mata_uang VARCHAR(45) NULL,
  brand_id VARCHAR(45) NULL,
  lini VARCHAR(45) NULL,
  PRIMARY KEY (id_invoice));
  
-- Tabel barang
CREATE TABLE barang (
  kode_barang VARCHAR(45) NOT NULL,
  sektor VARCHAR(45) NULL,
  nama_barang VARCHAR(45) NULL,
  tipe VARCHAR(45) NULL,
  nama_tipe VARCHAR(45) NULL,
  kode_lini VARCHAR(45) NULL,
  lini VARCHAR(45) NULL,
  kemasan VARCHAR(45) NULL,
  PRIMARY KEY (kode_barang));
  
-- Tabel pelanggan
CREATE TABLE pelanggan (
  id_customer VARCHAR(45) NOT NULL,
  level VARCHAR(45) NULL,
  nama VARCHAR(45) NULL,
  id_cabang VARCHAR(45) NULL,
  cabang_sales VARCHAR(45) NULL,
  id_group VARCHAR(45) NULL,
  jenis_group VARCHAR(45) NULL,
  PRIMARY KEY (id_customer));
  
/*
--------------------------
MEMBUAT TABEL BASE
--------------------------
*/

-- Cek unik value pada id_invoice
SELECT COUNT(DISTINCT(id_invoice)) FROM penjualan;


-- Membuat datamart base table penjualan
CREATE TABLE base_table AS (
SELECT
    j.id_invoice,
    j.tanggal,
    j.id_customer,
    c.nama,
    j.id_distributor,
    j.id_cabang,
    c.cabang_sales,
    c.id_group,
    c.jenis_group,
    j.id_barang,
    b.nama_barang,
    j.brand_id,
    b.kode_lini,
    j.lini,
    b.kemasan,
    j.jumlah,
    j.harga,
    j.mata_uang
FROM penjualan j
	LEFT JOIN pelanggan c
		ON c.id_customer = j.id_customer
	LEFT JOIN barang b
		ON b.kode_barang = j.id_barang
ORDER BY j.tanggal
);

-- Menentukan primary key
ALTER TABLE base_table ADD PRIMARY KEY(id_invoice);


/*
--------------------------
MEMBUAT TABEL AGGREGAT
--------------------------
*/

-- Membuat datamart aggregat table penjualan
CREATE TABLE agg_table AS (
SELECT
    tanggal,
	TO_CHAR(tanggal, 'Month') AS bulan,
    id_invoice,
    cabang_sales AS lokasi_cabang,
    nama AS pelanggan,
    nama_barang AS produk,
    lini AS merek,
    jumlah AS jumlah_produk_terjual,
    harga AS harga_satuan,
    (jumlah * harga) AS total_pendapatan
FROM base_table
ORDER BY 1, 4, 5, 6, 7, 8, 9, 10
);

select * from agg_table;