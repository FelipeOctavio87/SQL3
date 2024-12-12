
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES 
('admin@example.com', 'Felipe', 'Rebolledo', 'administrador'),
('victoria.robert@example.com', 'Victoria', 'Robert', 'usuario'),
('pedro.rebolledo@example.com', 'Pedro', 'Rebolledo', 'usuario'),
('natalia.rebolledo@example.com', 'Natalia', 'Rebolledo', 'usuario'),
('valeria.rebolledo@example.com', 'Valeria', 'Rebolledo', 'usuario');

CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN DEFAULT TRUE,
    usuario_id BIGINT REFERENCES Usuarios(id)
);

INSERT INTO Posts (titulo, contenido, usuario_id)
VALUES
('Post del administrador', 'En este post se inicializa los posts del administrador', 1),
('Reglas de Publicación de Contenido', 'En esta guía detallamos mejoresprácticas en la publicación de contenido', 1),
('Juegos Infantiles', 'Una lista de Juegos Infantiles para niños menores de 8 años', 2),
('Clases de Computación', 'Los temas mas relevantes de la computación hoy en día', 3),
('El impacto de las Fake News', 'Cuales son los impactos más relevantes de de las fake news en Chile', NULL);

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT REFERENCES Usuarios(id),
    post_id BIGINT REFERENCES Posts(id)
);

INSERT INTO Comentarios (contenido, usuario_id, post_id) 
VALUES
('Excelente post, muy informativo.', 1, 1), -- Comentario 1
('Me gustó mucho la explicación.', 2, 1),  -- Comentario 2
('Tengo algunas dudas, pero es útil.', 3, 1), -- Comentario 3
('Gran guía para publicar contenido.', 1, 2), -- Comentario 4
('Esto es justo lo que necesitaba.', 2, 2);  -- Comentario 5

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.
select u.nombre, u.email, p.titulo, p.contenido from Posts p 
	join Usuarios u on p.usuario_id = u.id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
--	a. El administrador puede ser cualquier id.
select p.id, p.titulo, p.contenido from Posts p 
	where p.usuario_id in (
		select u.id from Usuarios u where u.rol ='administrador'
	);

-- 4. Cuenta la cantidad de posts de cada usuario.
--  a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
select u.id, u.email, count(p.id) as posts from Posts p 
	join Usuarios u on p.usuario_id = u.id 
	group by p.usuario_id, u.id;

-- 5. Muestra el email del usuario que ha creado más posts.
--  a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
select u.email from Usuarios u 
	join Posts p on p.usuario_id = u.id 
	group by u.id, u.email 
	order by count(p.id) 
	desc limit 1;

-- 6. Muestra la fecha del último post de cada usuario.
select u.id, u.email, max(p.fecha_creacion) from Usuarios u 
	join Posts p on u.id=p.usuario_id 
	group by u.id, u.email;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.
select p.titulo, p.contenido from Posts p 
	join Comentarios c on c.post_id=p.id
	group by p.id, p.titulo, p.contenido
	order by count(c.id) desc
	limit 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario 
--		asociado a los posts mostrados, junto con el email del usuario que lo escribió.
select p.titulo, p.contenido, c.contenido, u.email from Posts p
	join Comentarios c on c.post_id = p.id
	join Usuarios u on c.usuario_id = u.id;

-- 9. Muestra el contenido del último comentario de cada usuario.
select u.email, c.contenido from Usuarios u
	join Comentarios c on c.usuario_id = u.id 
	where c.fecha_creacion in (
		select max(c.fecha_creacion) from Comentarios c where c.usuario_id = u.id
	);

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
select u.email from Usuarios u
	left join Comentarios c on u.id = c.usuario_id
	where c.id is null;




