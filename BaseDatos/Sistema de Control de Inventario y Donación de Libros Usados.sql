-- =============================================
-- SISTEMA DE CONTROL DE INVENTARIO
-- Y DONACION DE LIBROS USADOS
-- SQL Server 2019 o superior
-- Ejecutar una sola vez en una BD nueva de pruebas.
-- =============================================


-- 1. CREACION DE LA BASE DE DATOS


IF DB_ID(N'DonacionLibros') IS NULL
    CREATE DATABASE DonacionLibros;
GO


USE DonacionLibros;
GO


-- =============================================
-- 2. CREACION DE TABLAS
-- =============================================


-- TABLA ROL


CREATE TABLE dbo.Rol (
    id_rol INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    nombre NVARCHAR(40) NOT NULL UNIQUE,
    descripcion NVARCHAR(250) NULL
);


-- TABLA INSTITUCION


CREATE TABLE dbo.Institucion (
    id_institucion INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    nombre NVARCHAR(150) NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    direccion NVARCHAR(250) NOT NULL,
    responsable NVARCHAR(150) NOT NULL,
    activa BIT NOT NULL DEFAULT 1,


    CHECK (LEN(LTRIM(RTRIM(nombre))) > 0)
);


-- TABLA USUARIO


CREATE TABLE dbo.Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    id_institucion INT NOT NULL,
    id_rol INT NOT NULL,
    nombres NVARCHAR(100) NOT NULL,
    apellidos NVARCHAR(100) NOT NULL,
    correo NVARCHAR(254) NOT NULL UNIQUE,
    nombre_usuario NVARCHAR(80) NOT NULL UNIQUE,
    password_hash NVARCHAR(512) NOT NULL,
    activo BIT NOT NULL DEFAULT 1,


    FOREIGN KEY (id_institucion)
        REFERENCES dbo.Institucion(id_institucion),


    FOREIGN KEY (id_rol)
        REFERENCES dbo.Rol(id_rol)
);


-- TABLA PUBLICACIONLIBRO


CREATE TABLE dbo.PublicacionLibro (
    id_publicacion INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    id_institucion INT NOT NULL,
    titulo NVARCHAR(200) NOT NULL,
    autor NVARCHAR(150) NOT NULL,
    categoria NVARCHAR(80) NOT NULL,
    editorial NVARCHAR(150) NULL,
    anio SMALLINT NULL,
    isbn NVARCHAR(20) NULL,
    estado_fisico NVARCHAR(10) NOT NULL,
    cantidad_inicial INT NOT NULL,
    cantidad_disponible INT NOT NULL,
    cantidad_reservada INT NOT NULL DEFAULT 0,
    cantidad_entregada INT NOT NULL DEFAULT 0,
    activa BIT NOT NULL DEFAULT 1,
    fecha_registro DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),


    FOREIGN KEY (id_institucion)
        REFERENCES dbo.Institucion(id_institucion),


    CHECK (estado_fisico IN (N'Bueno', N'Regular')),
    CHECK (cantidad_inicial > 0),
    CHECK (cantidad_disponible >= 0),
    CHECK (cantidad_reservada >= 0),
    CHECK (cantidad_entregada >= 0),


    CONSTRAINT CK_Publicacion_Conservacion CHECK (
        CONVERT(BIGINT, cantidad_inicial) =
        CONVERT(BIGINT, cantidad_disponible) +
        cantidad_reservada +
        cantidad_entregada
    )
);


-- TABLA SOLICITUD


CREATE TABLE dbo.Solicitud (
    id_solicitud INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    id_publicacion INT NOT NULL,
    id_solicitante INT NOT NULL,
    id_institucion_solicitante INT NOT NULL,
    cantidad_solicitada INT NOT NULL,
    fecha_solicitud DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    estado NVARCHAR(15) NOT NULL DEFAULT N'Pendiente',
    observacion NVARCHAR(300) NULL,
    id_revisor INT NULL,
    fecha_revision DATETIME2(0) NULL,


    FOREIGN KEY (id_publicacion)
        REFERENCES dbo.PublicacionLibro(id_publicacion),


    FOREIGN KEY (id_solicitante)
        REFERENCES dbo.Usuario(id_usuario),


    FOREIGN KEY (id_institucion_solicitante)
        REFERENCES dbo.Institucion(id_institucion),


    FOREIGN KEY (id_revisor)
        REFERENCES dbo.Usuario(id_usuario),


    CHECK (cantidad_solicitada > 0),


    CHECK (estado IN (
        N'Pendiente',
        N'Aceptada',
        N'Rechazada',
        N'Cancelada'
    ))
);


-- TABLA RESERVA


CREATE TABLE dbo.Reserva (
    id_reserva INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    id_solicitud INT NOT NULL UNIQUE,
    cantidad_reservada INT NOT NULL,
    fecha_aprobacion DATETIME2(0) NOT NULL,
    fecha_vencimiento DATETIME2(0) NOT NULL,
    estado NVARCHAR(25) NOT NULL,
    id_ultimo_actor INT NULL,


    FOREIGN KEY (id_solicitud)
        REFERENCES dbo.Solicitud(id_solicitud),


    FOREIGN KEY (id_ultimo_actor)
        REFERENCES dbo.Usuario(id_usuario),


    CHECK (cantidad_reservada > 0),


    CHECK (estado IN (
        N'Activa',
        N'Parcialmente entregada',
        N'Completada',
        N'Cancelada',
        N'Vencida'
    )),


    CHECK (
        fecha_vencimiento = DATEADD(DAY, 5, fecha_aprobacion)
    )
);


-- TABLA ENTREGA


CREATE TABLE dbo.Entrega (
    id_entrega INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    id_reserva INT NOT NULL,
    id_responsable INT NOT NULL,
    cantidad_entregada INT NOT NULL,
    fecha_entrega DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    observacion NVARCHAR(300) NULL,
    clave_operacion UNIQUEIDENTIFIER NOT NULL UNIQUE,


    FOREIGN KEY (id_reserva)
        REFERENCES dbo.Reserva(id_reserva),


    FOREIGN KEY (id_responsable)
        REFERENCES dbo.Usuario(id_usuario),


    CHECK (cantidad_entregada > 0)
);


-- TABLA BITACORA


CREATE TABLE dbo.Bitacora (
    id_evento BIGINT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    entidad NVARCHAR(30) NOT NULL,
    id_entidad INT NOT NULL,
    accion NVARCHAR(40) NOT NULL,
    estado_anterior NVARCHAR(25) NULL,
    estado_nuevo NVARCHAR(25) NULL,
    id_usuario INT NULL,
    id_institucion INT NOT NULL,
    fecha DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    detalle NVARCHAR(400) NULL,


    FOREIGN KEY (id_usuario)
        REFERENCES dbo.Usuario(id_usuario),


    FOREIGN KEY (id_institucion)
        REFERENCES dbo.Institucion(id_institucion)
);
GO


-- =============================================
-- 3. REGISTRO DE ROLES
-- =============================================


INSERT INTO dbo.Rol (nombre)
VALUES
    (N'Administrador'),
    (N'Donante'),
    (N'Solicitante'),
    (N'ResponsableEntrega');
GO


-- =============================================
-- 4. INDICES NONCLUSTERED
-- =============================================


CREATE NONCLUSTERED INDEX IX_Publicacion_Titulo
ON dbo.PublicacionLibro (activa, titulo)
INCLUDE (
    autor, categoria, estado_fisico,
    cantidad_disponible, id_institucion
);


CREATE NONCLUSTERED INDEX IX_Solicitud_Publicacion
ON dbo.Solicitud (
    id_publicacion, estado, fecha_solicitud, id_solicitud
)
INCLUDE (cantidad_solicitada, id_institucion_solicitante);


CREATE NONCLUSTERED INDEX IX_Solicitud_Propia
ON dbo.Solicitud (id_institucion_solicitante, fecha_solicitud)
INCLUDE (estado, id_publicacion, cantidad_solicitada);


CREATE NONCLUSTERED INDEX IX_Reserva_Vencimiento
ON dbo.Reserva (estado, fecha_vencimiento);


CREATE NONCLUSTERED INDEX IX_Entrega_Reserva
ON dbo.Entrega (id_reserva, fecha_entrega)
INCLUDE (cantidad_entregada, id_responsable);
GO


-- =============================================
-- 5. VISTAS
-- =============================================


-- VISTA DEL INVENTARIO


CREATE VIEW dbo.vw_Inventario AS
SELECT
    id_publicacion,
    id_institucion,
    titulo,
    autor,
    categoria,
    estado_fisico,
    activa,
    cantidad_inicial,
    cantidad_disponible,
    cantidad_reservada,
    cantidad_entregada
FROM dbo.PublicacionLibro;
GO


-- VISTA DEL SALDO PENDIENTE DE LAS RESERVAS


CREATE VIEW dbo.vw_ReservaSaldo AS
SELECT
    r.id_reserva,
    r.id_solicitud,
    s.id_publicacion,
    s.id_institucion_solicitante,
    r.estado,
    r.fecha_aprobacion,
    r.fecha_vencimiento,
    r.cantidad_reservada,
    COALESCE(e.total, 0) AS entregado,


    r.cantidad_reservada -
        COALESCE(e.total, 0) AS no_entregado,


    CASE
        WHEN r.estado IN (
            N'Activa', N'Parcialmente entregada'
        )
        THEN r.cantidad_reservada - COALESCE(e.total, 0)
        ELSE 0
    END AS saldo_pendiente,


    CASE
        WHEN r.estado IN (N'Cancelada', N'Vencida')
        THEN r.cantidad_reservada - COALESCE(e.total, 0)
        ELSE 0
    END AS liberado


FROM dbo.Reserva r
INNER JOIN dbo.Solicitud s
    ON r.id_solicitud = s.id_solicitud
OUTER APPLY (
    SELECT SUM(CONVERT(BIGINT, cantidad_entregada)) AS total
    FROM dbo.Entrega e
    WHERE e.id_reserva = r.id_reserva
) e;
GO


-- VISTA DEL HISTORIAL DE ENTREGAS


CREATE VIEW dbo.vw_HistorialEntrega AS
SELECT
    e.id_entrega,
    e.id_reserva,
    s.id_publicacion,
    p.titulo,
    p.id_institucion AS id_donante,
    s.id_institucion_solicitante,
    e.id_responsable,
    e.fecha_entrega,
    e.cantidad_entregada,
    e.observacion


FROM dbo.Entrega e
INNER JOIN dbo.Reserva r
    ON e.id_reserva = r.id_reserva
INNER JOIN dbo.Solicitud s
    ON r.id_solicitud = s.id_solicitud
INNER JOIN dbo.PublicacionLibro p
    ON s.id_publicacion = p.id_publicacion;
GO


-- =============================================
-- 6. TRIGGER DE AUDITORIA
-- =============================================


CREATE TRIGGER dbo.tr_Reserva_Auditoria
ON dbo.Reserva
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;


    INSERT INTO dbo.Bitacora (
        entidad,
        id_entidad,
        accion,
        estado_anterior,
        estado_nuevo,
        id_usuario,
        id_institucion,
        detalle
    )
    SELECT
        N'Reserva',
        i.id_reserva,


        CASE
            WHEN d.id_reserva IS NULL THEN N'CREAR'
            ELSE N'CAMBIAR_ESTADO'
        END,


        d.estado,
        i.estado,
        i.id_ultimo_actor,
        p.id_institucion,


        CASE
            WHEN i.id_ultimo_actor IS NULL
            THEN N'Proceso automático del sistema'
            ELSE NULL
        END


    FROM inserted i
    LEFT JOIN deleted d
        ON i.id_reserva = d.id_reserva
    INNER JOIN dbo.Solicitud s
        ON i.id_solicitud = s.id_solicitud
    INNER JOIN dbo.PublicacionLibro p
        ON s.id_publicacion = p.id_publicacion


    WHERE d.id_reserva IS NULL
       OR d.estado <> i.estado;
END;
GO


-- =============================================
-- 7. PROCEDIMIENTOS ALMACENADOS
-- =============================================


-- PROCEDIMIENTO PARA REGISTRAR SOLICITUD
-- RF09


CREATE PROCEDURE dbo.sp_RegistrarSolicitud
    @actor INT,
    @publicacion INT,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @institucion INT;


    SELECT @institucion = u.id_institucion
    FROM dbo.Usuario u
    INNER JOIN dbo.Rol r ON r.id_rol = u.id_rol
    INNER JOIN dbo.Institucion i
        ON i.id_institucion = u.id_institucion
    WHERE u.id_usuario = @actor
      AND u.activo = 1
      AND i.activa = 1
      AND r.nombre = N'Solicitante';


    IF @institucion IS NULL
       OR @cantidad IS NULL
       OR @cantidad <= 0
        THROW 50001, N'Solicitante o cantidad inválidos.', 1;


    BEGIN TRY
        BEGIN TRANSACTION;


        IF NOT EXISTS (
            SELECT 1
            FROM dbo.PublicacionLibro p WITH (UPDLOCK, HOLDLOCK)
            INNER JOIN dbo.Institucion i
                ON i.id_institucion = p.id_institucion
            WHERE p.id_publicacion = @publicacion
              AND p.id_institucion <> @institucion
              AND p.activa = 1
              AND i.activa = 1
              AND p.cantidad_disponible >= @cantidad
        )
            THROW 50002, N'Publicación no disponible.', 1;


        INSERT INTO dbo.Solicitud (
            id_publicacion,
            id_solicitante,
            id_institucion_solicitante,
            cantidad_solicitada
        )
        VALUES (
            @publicacion,
            @actor,
            @institucion,
            @cantidad
        );


        DECLARE @id INT = SCOPE_IDENTITY();


        INSERT INTO dbo.Bitacora (
            entidad, id_entidad, accion,
            estado_nuevo, id_usuario, id_institucion
        )
        VALUES (
            N'Solicitud', @id, N'CREAR',
            N'Pendiente', @actor, @institucion
        );


        COMMIT TRANSACTION;


        SELECT @id AS id_solicitud;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- PROCEDIMIENTO PARA ACEPTAR SOLICITUD
-- RF12, RF13 Y RF16


CREATE PROCEDURE dbo.sp_AceptarSolicitud
    @actor INT,
    @solicitud INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @p INT;
    DECLARE @q INT;
    DECLARE @donante INT;
    DECLARE @solicitante INT;
    DECLARE @ahora DATETIME2(0) = SYSUTCDATETIME();


    BEGIN TRY
        BEGIN TRANSACTION;


        SELECT
            @p = id_publicacion,
            @q = cantidad_solicitada,
            @solicitante = id_institucion_solicitante
        FROM dbo.Solicitud WITH (UPDLOCK, HOLDLOCK)
        WHERE id_solicitud = @solicitud
          AND estado = N'Pendiente';


        IF @p IS NULL
            THROW 50003, N'Solicitud no pendiente.', 1;


        SELECT @donante = id_institucion
        FROM dbo.PublicacionLibro WITH (UPDLOCK, HOLDLOCK)
        WHERE id_publicacion = @p
          AND activa = 1;


        IF @donante IS NULL
           OR @donante = @solicitante
           OR NOT EXISTS (
                SELECT 1
                FROM dbo.Institucion
                WHERE id_institucion = @solicitante
                  AND activa = 1
           )
           OR NOT EXISTS (
                SELECT 1
                FROM dbo.Usuario u
                INNER JOIN dbo.Rol r ON r.id_rol = u.id_rol
                INNER JOIN dbo.Institucion i
                    ON i.id_institucion = u.id_institucion
                WHERE u.id_usuario = @actor
                  AND u.id_institucion = @donante
                  AND u.activo = 1
                  AND i.activa = 1
                  AND r.nombre = N'Donante'
           )
            THROW 50004, N'Operación no autorizada.', 1;


        UPDATE dbo.PublicacionLibro
        SET cantidad_disponible = cantidad_disponible - @q,
            cantidad_reservada = cantidad_reservada + @q
        WHERE id_publicacion = @p
          AND cantidad_disponible >= @q;


        IF @@ROWCOUNT <> 1
            THROW 50005, N'Stock insuficiente.', 1;


        UPDATE dbo.Solicitud
        SET estado = N'Aceptada',
            id_revisor = @actor,
            fecha_revision = @ahora
        WHERE id_solicitud = @solicitud;


        INSERT INTO dbo.Reserva (
            id_solicitud,
            cantidad_reservada,
            fecha_aprobacion,
            fecha_vencimiento,
            estado,
            id_ultimo_actor
        )
        VALUES (
            @solicitud,
            @q,
            @ahora,
            DATEADD(DAY, 5, @ahora),
            N'Activa',
            @actor
        );


        DECLARE @id INT = SCOPE_IDENTITY();


        INSERT INTO dbo.Bitacora (
            entidad, id_entidad, accion,
            estado_anterior, estado_nuevo,
            id_usuario, id_institucion
        )
        VALUES (
            N'Solicitud', @solicitud, N'ACEPTAR',
            N'Pendiente', N'Aceptada', @actor, @donante
        );


        COMMIT TRANSACTION;


        SELECT @id AS id_reserva;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- PROCEDIMIENTO PARA RECHAZAR SOLICITUD
-- RF12


CREATE PROCEDURE dbo.sp_RechazarSolicitud
    @actor INT,
    @solicitud INT,
    @motivo NVARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    BEGIN TRY
        BEGIN TRANSACTION;


        DECLARE @institucion INT;


        SELECT @institucion = p.id_institucion
        FROM dbo.Solicitud s WITH (UPDLOCK, HOLDLOCK)
        INNER JOIN dbo.PublicacionLibro p
            ON p.id_publicacion = s.id_publicacion
        WHERE s.id_solicitud = @solicitud
          AND s.estado = N'Pendiente';


        IF @institucion IS NULL OR NOT EXISTS (
            SELECT 1
            FROM dbo.Usuario u
            INNER JOIN dbo.Rol r ON r.id_rol = u.id_rol
            INNER JOIN dbo.Institucion i
                ON i.id_institucion = u.id_institucion
            WHERE u.id_usuario = @actor
              AND u.id_institucion = @institucion
              AND u.activo = 1
              AND i.activa = 1
              AND r.nombre = N'Donante'
        )
            THROW 50006, N'Solicitud no válida o acceso denegado.', 1;


        IF NULLIF(LTRIM(RTRIM(@motivo)), N'') IS NULL
            THROW 50007, N'Indique el motivo.', 1;


        UPDATE dbo.Solicitud
        SET estado = N'Rechazada',
            observacion = @motivo,
            id_revisor = @actor,
            fecha_revision = SYSUTCDATETIME()
        WHERE id_solicitud = @solicitud;


        INSERT INTO dbo.Bitacora (
            entidad, id_entidad, accion,
            estado_anterior, estado_nuevo,
            id_usuario, id_institucion, detalle
        )
        VALUES (
            N'Solicitud', @solicitud, N'RECHAZAR',
            N'Pendiente', N'Rechazada',
            @actor, @institucion, @motivo
        );


        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- PROCEDIMIENTO PARA REGISTRAR ENTREGA TOTAL O PARCIAL
-- RF15 Y RF16


CREATE PROCEDURE dbo.sp_RegistrarEntrega
    @actor INT,
    @reserva INT,
    @cantidad INT,
    @clave UNIQUEIDENTIFIER,
    @observacion NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @p INT;
    DECLARE @q INT;
    DECLARE @saldo BIGINT;
    DECLARE @estado NVARCHAR(25);
    DECLARE @vence DATETIME2(0);
    DECLARE @institucion INT;
    DECLARE @existente INT;


    BEGIN TRY
        BEGIN TRANSACTION;


        SELECT
            @q = r.cantidad_reservada,
            @estado = r.estado,
            @vence = r.fecha_vencimiento,
            @p = s.id_publicacion
        FROM dbo.Reserva r WITH (UPDLOCK, HOLDLOCK)
        INNER JOIN dbo.Solicitud s
            ON s.id_solicitud = r.id_solicitud
        WHERE r.id_reserva = @reserva;


        SELECT @institucion = id_institucion
        FROM dbo.PublicacionLibro
        WHERE id_publicacion = @p;


        IF @q IS NULL
           OR @clave IS NULL
           OR @cantidad IS NULL
           OR @cantidad <= 0
           OR NOT EXISTS (
                SELECT 1
                FROM dbo.Usuario u
                INNER JOIN dbo.Rol ro ON ro.id_rol = u.id_rol
                INNER JOIN dbo.Institucion i
                    ON i.id_institucion = u.id_institucion
                WHERE u.id_usuario = @actor
                  AND u.id_institucion = @institucion
                  AND u.activo = 1
                  AND i.activa = 1
                  AND ro.nombre = N'ResponsableEntrega'
           )
            THROW 50008, N'Datos inválidos o acceso denegado.', 1;


        SELECT @existente = id_entrega
        FROM dbo.Entrega
        WHERE clave_operacion = @clave
          AND id_reserva = @reserva
          AND id_responsable = @actor
          AND cantidad_entregada = @cantidad;


        IF @existente IS NOT NULL
        BEGIN
            COMMIT TRANSACTION;
            SELECT @existente AS id_entrega;
            RETURN;
        END;


        IF @estado NOT IN (
            N'Activa', N'Parcialmente entregada'
        ) OR @vence <= SYSUTCDATETIME()
            THROW 50009, N'Reserva no vigente.', 1;


        SELECT @saldo = @q -
            COALESCE(SUM(CONVERT(BIGINT, cantidad_entregada)), 0)
        FROM dbo.Entrega
        WHERE id_reserva = @reserva;


        IF @cantidad > @saldo
            THROW 50010, N'Cantidad supera el saldo pendiente.', 1;


        UPDATE dbo.PublicacionLibro
        SET cantidad_reservada = cantidad_reservada - @cantidad,
            cantidad_entregada = cantidad_entregada + @cantidad
        WHERE id_publicacion = @p
          AND cantidad_reservada >= @cantidad;


        IF @@ROWCOUNT <> 1
            THROW 50011, N'Inventario inconsistente.', 1;


        INSERT INTO dbo.Entrega (
            id_reserva,
            id_responsable,
            cantidad_entregada,
            observacion,
            clave_operacion
        )
        VALUES (
            @reserva,
            @actor,
            @cantidad,
            @observacion,
            @clave
        );


        DECLARE @id INT = SCOPE_IDENTITY();


        UPDATE dbo.Reserva
        SET estado =
            CASE
                WHEN @cantidad = @saldo
                THEN N'Completada'
                ELSE N'Parcialmente entregada'
            END,
            id_ultimo_actor = @actor
        WHERE id_reserva = @reserva;


        INSERT INTO dbo.Bitacora (
            entidad, id_entidad, accion,
            id_usuario, id_institucion, detalle
        )
        VALUES (
            N'Entrega', @id, N'REGISTRAR',
            @actor, @institucion,
            CONCAT(
                N'Cantidad: ', @cantidad,
                N'; saldo: ', @saldo - @cantidad
            )
        );


        COMMIT TRANSACTION;


        SELECT @id AS id_entrega;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- PROCEDIMIENTO INTERNO PARA LIBERAR RESERVAS
-- RF14 Y RF16


CREATE PROCEDURE dbo.sp_LiberarReserva
    @reserva INT,
    @actor INT = NULL,
    @vencimiento BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @p INT;
    DECLARE @q INT;
    DECLARE @saldo BIGINT;
    DECLARE @estado NVARCHAR(25);
    DECLARE @vence DATETIME2(0);
    DECLARE @institucion INT;


    BEGIN TRY
        BEGIN TRANSACTION;


        SELECT
            @q = r.cantidad_reservada,
            @estado = r.estado,
            @vence = r.fecha_vencimiento,
            @p = s.id_publicacion
        FROM dbo.Reserva r WITH (UPDLOCK, HOLDLOCK)
        INNER JOIN dbo.Solicitud s
            ON s.id_solicitud = r.id_solicitud
        WHERE r.id_reserva = @reserva;


        IF @q IS NULL
            THROW 50012, N'Reserva inexistente.', 1;


        IF @estado NOT IN (
            N'Activa', N'Parcialmente entregada'
        )
        BEGIN
            COMMIT TRANSACTION;
            RETURN;
        END;


        SELECT @institucion = id_institucion
        FROM dbo.PublicacionLibro
        WHERE id_publicacion = @p;


        IF @vencimiento = 1
        BEGIN
            IF @vence > SYSUTCDATETIME()
            BEGIN
                COMMIT TRANSACTION;
                RETURN;
            END;


            SET @actor = NULL;
        END
        ELSE IF NOT EXISTS (
            SELECT 1
            FROM dbo.Usuario u
            INNER JOIN dbo.Rol ro ON ro.id_rol = u.id_rol
            INNER JOIN dbo.Institucion i
                ON i.id_institucion = u.id_institucion
            WHERE u.id_usuario = @actor
              AND u.id_institucion = @institucion
              AND u.activo = 1
              AND i.activa = 1
              AND ro.nombre = N'Donante'
        )
            THROW 50013, N'Acceso denegado.', 1;


        SELECT @saldo = @q -
            COALESCE(SUM(CONVERT(BIGINT, cantidad_entregada)), 0)
        FROM dbo.Entrega
        WHERE id_reserva = @reserva;


        IF @saldo <= 0
            THROW 50014, N'Saldo inconsistente.', 1;


        UPDATE dbo.PublicacionLibro
        SET cantidad_disponible =
                cantidad_disponible + CONVERT(INT, @saldo),
            cantidad_reservada =
                cantidad_reservada - CONVERT(INT, @saldo)
        WHERE id_publicacion = @p
          AND cantidad_reservada >= @saldo;


        IF @@ROWCOUNT <> 1
            THROW 50015, N'Inventario inconsistente.', 1;


        UPDATE dbo.Reserva
        SET estado =
            CASE
                WHEN @vencimiento = 1 THEN N'Vencida'
                ELSE N'Cancelada'
            END,
            id_ultimo_actor = @actor
        WHERE id_reserva = @reserva;


        COMMIT TRANSACTION;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- PROCEDIMIENTO PARA CANCELAR RESERVAS
-- RF14


CREATE PROCEDURE dbo.sp_CancelarReserva
    @actor INT,
    @reserva INT
AS
BEGIN
    EXEC dbo.sp_LiberarReserva
        @reserva = @reserva,
        @actor = @actor,
        @vencimiento = 0;
END;
GO


-- PROCEDIMIENTO PARA VENCER RESERVAS
-- RF14 Y RD10


CREATE PROCEDURE dbo.sp_VencerReservas
AS
BEGIN
    SET NOCOUNT ON;


    DECLARE @id INT;


    DECLARE pendientes CURSOR LOCAL FAST_FORWARD FOR
        SELECT id_reserva
        FROM dbo.Reserva
        WHERE estado IN (
            N'Activa', N'Parcialmente entregada'
        )
        AND fecha_vencimiento <= SYSUTCDATETIME();


    OPEN pendientes;


    FETCH NEXT FROM pendientes INTO @id;


    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.sp_LiberarReserva
            @reserva = @id,
            @vencimiento = 1;


        FETCH NEXT FROM pendientes INTO @id;
    END;


    CLOSE pendientes;
    DEALLOCATE pendientes;
END;
GO


-- PROCEDIMIENTO PARA REGISTRAR Y ACTUALIZAR LIBROS
-- RF05 Y RF06


CREATE PROCEDURE dbo.sp_GuardarPublicacion
    @actor INT,
    @id INT = NULL,
    @titulo NVARCHAR(200),
    @autor NVARCHAR(150),
    @categoria NVARCHAR(80),
    @estado_fisico NVARCHAR(10),
    @inicial INT,
    @editorial NVARCHAR(150) = NULL,
    @anio SMALLINT = NULL,
    @isbn NVARCHAR(20) = NULL,
    @activa BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @institucion INT;


    SELECT @institucion = u.id_institucion
    FROM dbo.Usuario u
    INNER JOIN dbo.Rol r ON r.id_rol = u.id_rol
    INNER JOIN dbo.Institucion i
        ON i.id_institucion = u.id_institucion
    WHERE u.id_usuario = @actor
      AND u.activo = 1
      AND i.activa = 1
      AND r.nombre = N'Donante';


    IF @institucion IS NULL
       OR @inicial IS NULL
       OR @inicial <= 0
       OR NULLIF(LTRIM(RTRIM(@titulo)), N'') IS NULL
       OR NULLIF(LTRIM(RTRIM(@autor)), N'') IS NULL
       OR NULLIF(LTRIM(RTRIM(@categoria)), N'') IS NULL
        THROW 50016, N'Datos inválidos o acceso denegado.', 1;


    BEGIN TRY
        BEGIN TRANSACTION;


        IF @id IS NULL
        BEGIN
            INSERT INTO dbo.PublicacionLibro (
                id_institucion,
                titulo,
                autor,
                categoria,
                estado_fisico,
                cantidad_inicial,
                cantidad_disponible,
                editorial,
                anio,
                isbn,
                activa
            )
            VALUES (
                @institucion,
                @titulo,
                @autor,
                @categoria,
                @estado_fisico,
                @inicial,
                @inicial,
                @editorial,
                @anio,
                @isbn,
                @activa
            );


            SET @id = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE dbo.PublicacionLibro
            SET titulo = @titulo,
                autor = @autor,
                categoria = @categoria,
                estado_fisico = @estado_fisico,
                cantidad_inicial = @inicial,
                cantidad_disponible =
                    @inicial - cantidad_reservada - cantidad_entregada,
                editorial = @editorial,
                anio = @anio,
                isbn = @isbn,
                activa = @activa
            WHERE id_publicacion = @id
              AND id_institucion = @institucion
              AND @inicial >=
                  CONVERT(BIGINT, cantidad_reservada) +
                  cantidad_entregada;


            IF @@ROWCOUNT <> 1
                THROW 50017, N'Publicación no propia o cantidad comprometida.', 1;
        END;


        INSERT INTO dbo.Bitacora (
            entidad, id_entidad, accion,
            id_usuario, id_institucion, detalle
        )
        VALUES (
            N'PublicacionLibro', @id, N'GUARDAR',
            @actor, @institucion,
            CONCAT(N'Inicial: ', @inicial, N'; activa: ', @activa)
        );


        COMMIT TRANSACTION;


        SELECT @id AS id_publicacion;


    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO


-- =============================================
-- 8. SEGURIDAD Y ROLES DE BASE DE DATOS
-- =============================================


CREATE ROLE rol_api;
CREATE ROLE rol_vencimiento;
CREATE ROLE rol_auditoria;
GO


GRANT SELECT ON dbo.vw_Inventario TO rol_api;
GRANT SELECT ON dbo.vw_ReservaSaldo TO rol_api;
GRANT SELECT ON dbo.vw_HistorialEntrega TO rol_api;
GRANT SELECT ON dbo.Solicitud TO rol_api;


GRANT EXECUTE ON dbo.sp_RegistrarSolicitud TO rol_api;
GRANT EXECUTE ON dbo.sp_AceptarSolicitud TO rol_api;
GRANT EXECUTE ON dbo.sp_RechazarSolicitud TO rol_api;
GRANT EXECUTE ON dbo.sp_RegistrarEntrega TO rol_api;
GRANT EXECUTE ON dbo.sp_CancelarReserva TO rol_api;
GRANT EXECUTE ON dbo.sp_GuardarPublicacion TO rol_api;


GRANT EXECUTE ON dbo.sp_VencerReservas TO rol_vencimiento;


GRANT SELECT ON dbo.Bitacora TO rol_auditoria;
GO


-- =============================================
-- 9. RESPALDO DE BASE DE DATOS
-- =============================================


-- Descomentar cuando exista la carpeta D:\Backups
-- y el servidor tenga permisos de escritura.


/*
BACKUP DATABASE DonacionLibros
TO DISK = N'D:\Backups\DonacionLibros.bak'
WITH CHECKSUM, COMPRESSION, STATS = 10;


RESTORE VERIFYONLY
FROM DISK = N'D:\Backups\DonacionLibros.bak'
WITH CHECKSUM;
*/


-- =============================================
-- 10. CONSULTAS DE VERIFICACION
-- =============================================


-- Mostrar las tablas creadas


SELECT name AS NombreTabla
FROM sys.tables
ORDER BY name;


-- Mostrar los roles registrados


SELECT * FROM dbo.Rol;


-- Consultar inventario


SELECT * FROM dbo.vw_Inventario;


-- Consultar reservas y saldos pendientes


SELECT * FROM dbo.vw_ReservaSaldo;


-- Consultar historial de entregas


SELECT * FROM dbo.vw_HistorialEntrega;


-- Consultar bitacora


SELECT * FROM dbo.Bitacora;


-- Mostrar los indices creados


SELECT
    t.name AS Tabla,
    i.name AS Indice,
    i.type_desc AS TipoIndice
FROM sys.indexes i
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
ORDER BY t.name, i.name;

