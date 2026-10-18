USE master;
GO

IF DB_ID('FarmaciaSaludVida') IS NOT NULL
BEGIN
    ALTER DATABASE FarmaciaSaludVida SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FarmaciaSaludVida;
END
GO

CREATE DATABASE FarmaciaSaludVida;
GO

ALTER AUTHORIZATION ON DATABASE::FarmaciaSaludVida TO sa;
GO

USE FarmaciaSaludVida;
GO

CREATE TABLE Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL UNIQUE,
    Descripcion VARCHAR(150) NULL
);
GO

CREATE TABLE Proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    NombreEmpresa VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NOT NULL,
    Ciudad VARCHAR(50) DEFAULT 'Bogotá'
);
GO

CREATE TABLE Medicamentos (
    MedicamentoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreComercial VARCHAR(100) NOT NULL,
    PrincipioActivo VARCHAR(100) NOT NULL,
    CategoriaID INT NOT NULL,
    ProveedorID INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario > 0),
    Stock INT NOT NULL DEFAULT 0 CHECK (Stock >= 0),
    FechaExpiracion DATE NOT NULL,
    CONSTRAINT FK_Medicamentos_Categorias FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    CONSTRAINT FK_Medicamentos_Proveedores FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID)
);
GO

CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Cedula VARCHAR(20) NOT NULL UNIQUE,
    NombreCompleto VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20) NULL,
    CorreoElectronico VARCHAR(100) UNIQUE,
    FechaRegistro DATE DEFAULT GETDATE()
);
GO

CREATE TABLE Ventas (
    VentaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaVenta DATE NOT NULL DEFAULT GETDATE(),
    TotalVenta DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT FK_Ventas_Clientes FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);
GO

CREATE TABLE DetalleVentas (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    VentaID INT NOT NULL,
    MedicamentoID INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleVentas_Ventas FOREIGN KEY (VentaID) REFERENCES Ventas(VentaID),
    CONSTRAINT FK_DetalleVentas_Medicamentos FOREIGN KEY (MedicamentoID) REFERENCES Medicamentos(MedicamentoID)
);
GO

ALTER TABLE Clientes
ADD Direccion VARCHAR(150) DEFAULT 'Sin dirección registrada';
GO

INSERT INTO Categorias (NombreCategoria, Descripcion) VALUES
('Analgésicos', 'Medicamentos para aliviar el dolor'),
('Antibióticos', 'Fármacos para combatir infecciones bacterianas'),
('Antiinflamatorios', 'Reducen la inflamación y la fiebre'),
('Antihistamínicos', 'Para el tratamiento de alergias'),
('Antitusivos', 'Control y alivio de la tos'),
('Antidiarreicos', 'Tratamiento de afecciones digestivas'),
('Vitaminas y Minerales', 'Suplementos nutricionales'),
('Antiácidos', 'Alivio de la acidez estomacal'),
('Antifúngicos', 'Tratamiento de infecciones por hongos'),
('Cardiovasculares', 'Control de la presión arterial'),
('Dermatológicos', 'Cremas y lociones para la piel'),
('Oftálmicos', 'Gotas y tratamientos para los ojos'),
('Ansiolíticos', 'Control leve de la ansiedad'),
('Antidiabéticos', 'Control de los niveles de azúcar'),
('Anestésicos Locales', 'Cremas o geles anestésicos'),
('Antisépticos', 'Desinfección de heridas'),
('Mucolíticos', 'Disminuyen la viscosidad del moco'),
('Broncodilatadores', 'Ayudan a respirar mejor'),
('Hipolipemiantes', 'Control del colesterol'),
('Sueros Orales', 'Rehidratación corporal');
GO

INSERT INTO Proveedores (NombreEmpresa, Telefono, Ciudad) VALUES
('Laboratorios Bayer S.A.', '3104567890', 'Bogotá'),
('Farmacéutica Pfizer', '3112345678', 'Medellín'),
('Genéricos de Colombia', '3129876543', 'Cali'),
('Distribuidora La Santé', '3135551234', 'Barranquilla'),
('Novartis de Colombia', '3146667890', 'Bogotá'),
('Sanofi Aventis', '3157778901', 'Medellín'),
('Abbott Laboratories', '3168889012', 'Cali'),
('Merck Sharp & Dohme', '3179990123', 'Bucaramanga'),
('Tecnofarma S.A.', '3181112345', 'Bogotá'),
('Baxter Healthcare', '3192223456', 'Medellín'),
('GSK Colombia', '3203334567', 'Cali'),
('Janssen-Cilag', '3214445678', 'Barranquilla'),
('AstraZeneca', '3225556789', 'Bogotá'),
('B. Braun Medical', '3236667890', 'Medellín'),
('Roemmers S.A.', '3247778901', 'Cali'),
('Procaps S.A.', '3258889012', 'Barranquilla'),
('Colgate-Palmolive', '3269990123', 'Bogotá'),
('MK Tecnofarma', '3271112345', 'Medellín'),
('Farmasierra', '3282223456', 'Cali'),
('Vitalis S.A.C.I.', '3293334567', 'Bogotá');
GO

INSERT INTO Medicamentos (NombreComercial, PrincipioActivo, CategoriaID, ProveedorID, PrecioUnitario, Stock, FechaExpiracion) VALUES
('Dolex Forte', 'Paracetamol', 1, 1, 12500.00, 150, '2028-05-12'),
('Amoxicilina 500mg', 'Amoxicilina', 2, 2, 28000.00, 80, '2027-11-20'),
('Ibuprofeno 400mg', 'Ibuprofeno', 3, 3, 9500.00, 200, '2028-02-15'),
('Loratadina 10mg', 'Loratadina', 4, 4, 7200.00, 120, '2027-09-10'),
('Tabcin Active', 'Fenilefrina / Paracetamol', 1, 1, 15000.00, 95, '2028-08-30'),
('Buscapina Compuesta', 'Hioscina / Metamizol', 1, 5, 18500.00, 110, '2028-01-05'),
('Azitromicina 500mg', 'Azitromicina', 2, 2, 45000.00, 60, '2027-06-18'),
('Naproxeno 250mg', 'Naproxeno', 3, 3, 14000.00, 140, '2028-10-12'),
('Cetirizina 10mg', 'Cetirizina', 4, 4, 6800.00, 175, '2028-04-22'),
('Bisolvon Jarabe', 'Bromhexina', 17, 6, 22000.00, 50, '2027-12-01'),
('Imodium', 'Loperamida', 6, 7, 8500.00, 90, '2028-03-14'),
('Centrum Adultos', 'Multivitamínico', 7, 7, 65000.00, 45, '2029-01-10'),
('Maalox Suspensión', 'Hidróxido de Aluminio / Magnesio', 8, 8, 24000.00, 70, '2028-07-19'),
('Clotrimazol Crema', 'Clotrimazol', 9, 9, 16000.00, 65, '2027-10-30'),
('Losartán 50mg', 'Losartán Potásico', 10, 10, 21000.00, 130, '2028-09-15'),
('Nopucid Loción', 'Deltametrina', 11, 11, 19000.00, 40, '2027-08-25'),
('Vispring Gotas', 'Tetrizolina', 12, 12, 17500.00, 85, '2027-05-11'),
('Metformina 850mg', 'Clorhidrato de Metformina', 14, 13, 13500.00, 210, '2028-11-30'),
('Salbutamol Inhalador', 'Salbutamol', 18, 14, 32000.00, 55, '2027-04-01'),
('Suero Oral 500ml', 'Electrolitos Orales', 20, 15, 5500.00, 300, '2029-02-28');
GO

INSERT INTO Clientes (Cedula, NombreCompleto, Telefono, CorreoElectronico, FechaRegistro) VALUES
('1010123456', 'María Fernanda Gómez', '3001112233', 'maria.gomez@gmail.com', '2026-01-10'),
('1020234567', 'Carlos Alberto Pérez', '3012223344', 'carlos.perez@hotmail.com', '2026-01-12'),
('1030345678', 'Ana María Rodríguez', '3023334455', 'ana.rodriguez@yahoo.com', '2026-01-15'),
('1040456789', 'Luis Fernando Torres', '3034445566', 'luis.torres@outlook.com', '2026-01-18'),
('1050567890', 'Diana Carolina Rojas', '3045556677', 'diana.rojas@gmail.com', '2026-01-20'),
('1060678901', 'Jorge Enrique Morales', '3056667788', 'jorge.morales@gmail.com', '2026-02-01'),
('1070789012', 'Paola Andrea Silva', '3067778899', 'paola.silva@hotmail.com', '2026-02-05'),
('1080890123', 'Andrés Felipe Castro', '3078889900', 'andres.castro@gmail.com', '2026-02-08'),
('1090901234', 'Claudia Patricia Vargas', '3089990011', 'claudia.vargas@yahoo.com', '2026-02-12'),
('1101012345', 'Ricardo José Mendoza', '3090001122', 'ricardo.mendoza@outlook.com', '2026-02-15'),
('1111123456', 'Sandra Milena Ospina', '3101112233', 'sandra.ospina@gmail.com', '2026-02-20'),
('1121234567', 'Felipe Santiago Restrepo', '3112223344', 'felipe.restrepo@gmail.com', '2026-02-22'),
('1131345678', 'Natalia Andrea Jaramillo', '3123334455', 'natalia.jaramillo@hotmail.com', '2026-03-01'),
('1141456789', 'Héctor Julio Betancur', '3134445566', 'hector.betancur@yahoo.com', '2026-03-03'),
('1151567890', 'Marcela Giraldo Henao', '3145556677', 'marcela.giraldo@gmail.com', '2026-03-05'),
('1161678901', 'Esteban David Quintero', '3156667788', 'esteban.quintero@outlook.com', '2026-03-10'),
('1171789012', 'Valeria Sofía Murillo', '3167778899', 'valeria.murillo@gmail.com', '2026-03-12'),
('1181890123', 'Mauricio Alejandro Ríos', '3178889900', 'mauricio.rios@hotmail.com', '2026-03-15'),
('1191901234', 'Liliana Patricia Arango', '3189990011', 'liliana.arango@gmail.com', '2026-03-18'),
('1202012345', 'Gabriel Jaime Londoño', '3190001122', 'gabriel.londono@yahoo.com', '2026-03-20');
GO

INSERT INTO Ventas (ClienteID, FechaVenta, TotalVenta) VALUES
(1, '2026-03-01', 12500.00),
(2, '2026-03-02', 28000.00),
(3, '2026-03-03', 19000.00),
(4, '2026-03-05', 7200.00),
(5, '2026-03-08', 30000.00),
(6, '2026-03-10', 18500.00),
(7, '2026-03-11', 45000.00),
(8, '2026-03-12', 14000.00),
(9, '2026-03-14', 65000.00),
(10, '2026-03-15', 24000.00),
(11, '2026-03-16', 21000.00),
(12, '2026-03-18', 13500.00),
(13, '2026-03-19', 32000.00),
(14, '2026-03-20', 11000.00),
(15, '2026-03-22', 15000.00),
(1, '2026-03-23', 9500.00),
(2, '2026-03-24', 28000.00),
(3, '2026-03-25', 16000.00),
(4, '2026-03-26', 17500.00),
(5, '2026-03-27', 22000.00);
GO

INSERT INTO DetalleVentas (VentaID, MedicamentoID, Cantidad, Subtotal) VALUES
(1, 1, 1, 12500.00),
(2, 2, 1, 28000.00),
(3, 3, 2, 19000.00),
(4, 4, 1, 7200.00),
(5, 5, 2, 30000.00),
(6, 6, 1, 18500.00),
(7, 7, 1, 45000.00),
(8, 8, 1, 14000.00),
(9, 12, 1, 65000.00),
(10, 13, 1, 24000.00),
(11, 15, 1, 21000.00),
(12, 18, 1, 13500.00),
(13, 19, 1, 32000.00),
(14, 20, 2, 11000.00),
(15, 5, 1, 15000.00),
(16, 3, 1, 9500.00),
(17, 2, 1, 28000.00),
(18, 14, 1, 16000.00),
(19, 17, 1, 17500.00),
(20, 10, 1, 22000.00);
GO

UPDATE Clientes
SET Direccion = 'Calle 50 # 45-10, Bello'
WHERE ClienteID = 1;
GO

UPDATE Medicamentos
SET Stock = Stock - 5
WHERE MedicamentoID = 1;
GO

-- Consulta 1: Clientes cuyo total acumulado de compras supera 20,000
SELECT
    c.NombreCompleto,
    SUM(v.TotalVenta) AS TotalAcumuladoCompras
FROM Clientes c
INNER JOIN Ventas v ON c.ClienteID = v.ClienteID
WHERE v.FechaVenta >= '2026-03-01'
GROUP BY c.NombreCompleto
HAVING SUM(v.TotalVenta) > 20000.00
ORDER BY TotalAcumuladoCompras ASC;
GO

-- Consulta 2: Categorias con precio promedio mayor a 15,000 y cantidad de medicamentos
SELECT
    cat.NombreCategoria,
    COUNT(m.MedicamentoID) AS CantidadMedicamentos,
    AVG(m.PrecioUnitario) AS PrecioPromedio
FROM Categorias cat
INNER JOIN Medicamentos m ON cat.CategoriaID = m.CategoriaID
GROUP BY cat.NombreCategoria
HAVING AVG(m.PrecioUnitario) > 15000.00
ORDER BY PrecioPromedio DESC;
GO

-- Consulta 3: Proveedores con ventas superiores a 25,000 durante marzo de 2026
SELECT
    p.NombreEmpresa AS Proveedor,
    SUM(dv.Subtotal) AS TotalVentasProveedor
FROM Proveedores p
INNER JOIN Medicamentos m ON p.ProveedorID = m.ProveedorID
INNER JOIN DetalleVentas dv ON m.MedicamentoID = dv.MedicamentoID
INNER JOIN Ventas v ON dv.VentaID = v.VentaID
WHERE v.FechaVenta BETWEEN '2026-03-01' AND '2026-03-31'
GROUP BY p.NombreEmpresa
HAVING SUM(dv.Subtotal) > 25000.00
ORDER BY TotalVentasProveedor DESC;
GO

-- Consulta 4: Ciudades de proveedores con inventario total mayor a 100 unidades
SELECT
    p.Ciudad,
    SUM(m.Stock) AS StockTotalCiudad
FROM Proveedores p
INNER JOIN Medicamentos m ON p.ProveedorID = m.ProveedorID
GROUP BY p.Ciudad
HAVING SUM(m.Stock) > 100
ORDER BY StockTotalCiudad DESC;
GO

-- Consulta 5: Clientes con mas de una compra, su primera compra y cantidad de compras
SELECT
    c.NombreCompleto,
    COUNT(v.VentaID) AS NumeroDeCompras,
    MIN(v.FechaVenta) AS PrimeraCompraPeriodo
FROM Clientes c
INNER JOIN Ventas v ON c.ClienteID = v.ClienteID
WHERE v.FechaVenta >= '2026-01-01'
GROUP BY c.NombreCompleto
HAVING COUNT(v.VentaID) > 1
ORDER BY NumeroDeCompras DESC;
GO

-- Consulta 6: Clientes registrados que nunca han comprado (LEFT JOIN)
SELECT
    c.NombreCompleto,
    COUNT(v.VentaID) AS NumeroDeCompras
FROM Clientes c
LEFT JOIN Ventas v ON c.ClienteID = v.ClienteID
GROUP BY c.NombreCompleto
HAVING COUNT(v.VentaID) = 0
ORDER BY c.NombreCompleto;
GO
