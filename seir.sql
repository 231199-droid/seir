-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-12-2025 a las 02:45:28
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `seir`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

CREATE TABLE `administrador` (
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alternativa`
--

CREATE TABLE `alternativa` (
  `id_alternativa` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `texto` varchar(255) NOT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alternativa`
--

INSERT INTO `alternativa` (`id_alternativa`, `id_pregunta`, `texto`, `es_correcta`) VALUES
(9, 2, 'pedrito', 0),
(10, 2, 'carlitos', 1),
(11, 2, 'batman', 0),
(12, 2, 'fernan', 0),
(13, 3, 'si', 0),
(14, 3, 'creo que si', 0),
(15, 3, 'soy kbrazo', 1),
(16, 4, 'si', 1),
(17, 4, 'no', 0),
(18, 4, 'tal vez', 0),
(19, 4, 'no lo sé', 0),
(20, 5, 'azul', 0),
(21, 5, 'verde', 0),
(22, 5, 'celeste', 0),
(23, 5, 'ninguno', 1);

--
-- Disparadores `alternativa`
--
DELIMITER $$
CREATE TRIGGER `trg_alt_correcta_ins` BEFORE INSERT ON `alternativa` FOR EACH ROW BEGIN
  IF NEW.es_correcta = TRUE THEN
    IF (SELECT COUNT(*) FROM alternativa
        WHERE id_pregunta = NEW.id_pregunta AND es_correcta = TRUE) > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe una alternativa correcta para esta pregunta.';
    END IF;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_alt_correcta_upd` BEFORE UPDATE ON `alternativa` FOR EACH ROW BEGIN
  IF NEW.es_correcta = TRUE AND OLD.es_correcta = FALSE THEN
    IF (SELECT COUNT(*) FROM alternativa
        WHERE id_pregunta = NEW.id_pregunta AND es_correcta = TRUE) > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe una alternativa correcta para esta pregunta.';
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `computadora`
--

CREATE TABLE `computadora` (
  `id_computadora` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'ACTIVA',
  `ultimo_ping` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `id_admin_supervisor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id_config` int(11) NOT NULL,
  `parametro` varchar(80) NOT NULL,
  `valor` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docente`
--

CREATE TABLE `docente` (
  `id_usuario` int(11) NOT NULL,
  `especialidad` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `docente`
--

INSERT INTO `docente` (`id_usuario`, `especialidad`) VALUES
(2, 'Matemática');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--

CREATE TABLE `estudiante` (
  `id_usuario` int(11) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `grado` varchar(30) NOT NULL,
  `seccion` varchar(30) NOT NULL,
  `id_computadora` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id_usuario`, `dni`, `grado`, `seccion`, `id_computadora`) VALUES
(3, '70000001', '5to', 'A', NULL),
(4, '70000002', '5to', 'A', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `participante`
--

CREATE TABLE `participante` (
  `id_participante` int(11) NOT NULL,
  `id_partida` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `alias` varchar(60) NOT NULL,
  `fecha_union` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `participante`
--

INSERT INTO `participante` (`id_participante`, `id_partida`, `id_estudiante`, `alias`, `fecha_union`) VALUES
(1, 2, 3, 'ana01', '2025-12-12 19:41:21'),
(2, 1, 3, 'ana01', '2025-12-12 20:19:40'),
(3, 3, 3, 'ana01', '2025-12-12 20:30:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partida`
--

CREATE TABLE `partida` (
  `id_partida` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `titulo` varchar(150) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'CREADA',
  `tiempo_pregunta` int(11) NOT NULL DEFAULT 30,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `id_docente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `partida`
--

INSERT INTO `partida` (`id_partida`, `codigo`, `titulo`, `estado`, `tiempo_pregunta`, `fecha_inicio`, `fecha_fin`, `created_at`, `id_docente`) VALUES
(1, 'SEIR-80269', 'practica', 'FINALIZADA', 30, '2025-12-12 20:19:08', '2025-12-12 20:24:56', '2025-12-12 19:26:06', 2),
(2, 'SEIR-13832', 'sasasas', 'FINALIZADA', 30, '2025-12-12 20:02:38', '2025-12-12 20:18:56', '2025-12-12 19:39:10', 2),
(3, 'SEIR-03854', 'pregunt12', 'EN_CURSO', 40, '2025-12-12 20:28:51', NULL, '2025-12-12 20:28:23', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `partida_pregunta`
--

CREATE TABLE `partida_pregunta` (
  `id` int(11) NOT NULL,
  `id_partida` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `orden` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `partida_pregunta`
--

INSERT INTO `partida_pregunta` (`id`, `id_partida`, `id_pregunta`, `orden`) VALUES
(9, 1, 3, 1),
(10, 1, 2, 2),
(13, 2, 3, 1),
(14, 2, 2, 2),
(15, 3, 5, 1),
(16, 3, 4, 2),
(17, 3, 3, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pregunta`
--

CREATE TABLE `pregunta` (
  `id_pregunta` int(11) NOT NULL,
  `enunciado` text NOT NULL,
  `dificultad` varchar(20) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `id_docente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pregunta`
--

INSERT INTO `pregunta` (`id_pregunta`, `enunciado`, `dificultad`, `activo`, `created_at`, `id_docente`) VALUES
(2, 'como se llama el señor de la noche?', 'MEDIA', 1, '2025-12-12 18:57:45', 2),
(3, 'santos ¿eres o no eres?', 'FACIL', 1, '2025-12-12 19:17:10', 2),
(4, 'eres amarillo?', 'MEDIA', 1, '2025-12-12 20:26:43', 2),
(5, 'de que color era el caballo 🐴 de miguel grau?', 'FACIL', 1, '2025-12-12 20:27:59', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta`
--

CREATE TABLE `respuesta` (
  `id_respuesta` int(11) NOT NULL,
  `id_participante` int(11) NOT NULL,
  `id_partida_pregunta` int(11) NOT NULL,
  `id_alternativa` int(11) NOT NULL,
  `tiempo_respuesta` decimal(8,2) NOT NULL,
  `puntaje_obtenido` decimal(10,2) NOT NULL DEFAULT 0.00,
  `fecha_respuesta` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `respuesta`
--

INSERT INTO `respuesta` (`id_respuesta`, `id_participante`, `id_partida_pregunta`, `id_alternativa`, `tiempo_respuesta`, `puntaje_obtenido`, `fecha_respuesta`) VALUES
(1, 1, 13, 15, 12.21, 1.00, '2025-12-12 20:03:17'),
(2, 1, 14, 10, 8.01, 1.00, '2025-12-12 20:03:25'),
(3, 2, 9, 15, 12.53, 1.00, '2025-12-12 20:19:53'),
(4, 2, 10, 12, 5.51, 0.00, '2025-12-12 20:19:58'),
(5, 3, 15, 23, 13.86, 1.00, '2025-12-12 20:30:27'),
(6, 3, 16, 17, 6.47, 0.00, '2025-12-12 20:30:33'),
(7, 3, 17, 13, 7.13, 0.00, '2025-12-12 20:30:40');

--
-- Disparadores `respuesta`
--
DELIMITER $$
CREATE TRIGGER `trg_respuesta_puntaje_auto` BEFORE INSERT ON `respuesta` FOR EACH ROW BEGIN
  DECLARE v_correcta BOOLEAN;
  SELECT es_correcta INTO v_correcta
  FROM alternativa
  WHERE id_alternativa = NEW.id_alternativa;

  SET NEW.puntaje_obtenido = IF(v_correcta = TRUE, 1, 0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_respuesta_validar_alt` BEFORE INSERT ON `respuesta` FOR EACH ROW BEGIN
  DECLARE v_id_pregunta_pp INT;
  DECLARE v_id_pregunta_alt INT;

  SELECT id_pregunta INTO v_id_pregunta_pp
  FROM partida_pregunta
  WHERE id = NEW.id_partida_pregunta;

  SELECT id_pregunta INTO v_id_pregunta_alt
  FROM alternativa
  WHERE id_alternativa = NEW.id_alternativa;

  IF v_id_pregunta_pp IS NULL OR v_id_pregunta_alt IS NULL OR v_id_pregunta_pp <> v_id_pregunta_alt THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La alternativa no pertenece a la pregunta de esta partida.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombres` varchar(120) NOT NULL,
  `apellidos` varchar(120) NOT NULL,
  `username` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'ACTIVO',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombres`, `apellidos`, `username`, `password_hash`, `estado`, `created_at`) VALUES
(2, 'Carlos', 'Docente', 'docente1', '$2y$10$vtkz1/FMz7NS6wi/vw3Cfen/yGawXM/SpWyI6Z8JNRyFEEoTTLfFG', 'ACTIVO', '2025-12-12 18:18:38'),
(3, 'ana', 'perez', '70000001', '$2y$10$FQJkvbGzHvwMh03kiFQYTu7D4TotFCxfVgsiXptCBnRCAoxYur5zm', 'ACTIVO', '2025-12-12 18:39:30'),
(4, 'Juan', 'perez', '70000002', '$2y$10$rH.hFJwS1aT36HRtt3c2.eS494ExW0M4zcAr7D5Fgo9yEOyQtTZYi', 'ACTIVO', '2025-12-12 18:40:12');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_ranking_partida`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_ranking_partida` (
`id_partida` int(11)
,`codigo_partida` varchar(30)
,`titulo` varchar(150)
,`id_participante` int(11)
,`alias` varchar(60)
,`nombres` varchar(120)
,`apellidos` varchar(120)
,`puntaje_total` decimal(32,2)
,`respuestas_registradas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_ranking_partida`
--
DROP TABLE IF EXISTS `vw_ranking_partida`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_ranking_partida`  AS SELECT `p`.`id_partida` AS `id_partida`, `p`.`codigo` AS `codigo_partida`, `p`.`titulo` AS `titulo`, `par`.`id_participante` AS `id_participante`, `par`.`alias` AS `alias`, `u`.`nombres` AS `nombres`, `u`.`apellidos` AS `apellidos`, sum(`r`.`puntaje_obtenido`) AS `puntaje_total`, count(`r`.`id_respuesta`) AS `respuestas_registradas` FROM ((((`participante` `par` join `partida` `p` on(`p`.`id_partida` = `par`.`id_partida`)) join `estudiante` `e` on(`e`.`id_usuario` = `par`.`id_estudiante`)) join `usuario` `u` on(`u`.`id_usuario` = `e`.`id_usuario`)) left join `respuesta` `r` on(`r`.`id_participante` = `par`.`id_participante`)) GROUP BY `p`.`id_partida`, `p`.`codigo`, `p`.`titulo`, `par`.`id_participante`, `par`.`alias`, `u`.`nombres`, `u`.`apellidos` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `alternativa`
--
ALTER TABLE `alternativa`
  ADD PRIMARY KEY (`id_alternativa`),
  ADD KEY `idx_alt_pregunta` (`id_pregunta`);

--
-- Indices de la tabla `computadora`
--
ALTER TABLE `computadora`
  ADD PRIMARY KEY (`id_computadora`),
  ADD UNIQUE KEY `uk_pc_codigo` (`codigo`),
  ADD UNIQUE KEY `uk_pc_ip` (`ip`),
  ADD KEY `fk_pc_admin` (`id_admin_supervisor`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id_config`),
  ADD UNIQUE KEY `uk_config_parametro` (`parametro`);

--
-- Indices de la tabla `docente`
--
ALTER TABLE `docente`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uk_estudiante_dni` (`dni`),
  ADD KEY `idx_estudiante_pc` (`id_computadora`);

--
-- Indices de la tabla `participante`
--
ALTER TABLE `participante`
  ADD PRIMARY KEY (`id_participante`),
  ADD UNIQUE KEY `uk_participante_partida_est` (`id_partida`,`id_estudiante`),
  ADD UNIQUE KEY `uk_participante_partida_alias` (`id_partida`,`alias`),
  ADD KEY `idx_participante_partida` (`id_partida`),
  ADD KEY `idx_participante_estudiante` (`id_estudiante`);

--
-- Indices de la tabla `partida`
--
ALTER TABLE `partida`
  ADD PRIMARY KEY (`id_partida`),
  ADD UNIQUE KEY `uk_partida_codigo` (`codigo`),
  ADD KEY `idx_partida_docente` (`id_docente`);

--
-- Indices de la tabla `partida_pregunta`
--
ALTER TABLE `partida_pregunta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_pp_partida_pregunta` (`id_partida`,`id_pregunta`),
  ADD UNIQUE KEY `uk_pp_partida_orden` (`id_partida`,`orden`),
  ADD KEY `idx_pp_partida` (`id_partida`),
  ADD KEY `idx_pp_pregunta` (`id_pregunta`);

--
-- Indices de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD PRIMARY KEY (`id_pregunta`),
  ADD KEY `idx_pregunta_docente` (`id_docente`);

--
-- Indices de la tabla `respuesta`
--
ALTER TABLE `respuesta`
  ADD PRIMARY KEY (`id_respuesta`),
  ADD UNIQUE KEY `uk_resp_unica` (`id_participante`,`id_partida_pregunta`),
  ADD KEY `idx_resp_participante` (`id_participante`),
  ADD KEY `idx_resp_pp` (`id_partida_pregunta`),
  ADD KEY `idx_resp_alt` (`id_alternativa`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uk_usuario_username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alternativa`
--
ALTER TABLE `alternativa`
  MODIFY `id_alternativa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `computadora`
--
ALTER TABLE `computadora`
  MODIFY `id_computadora` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id_config` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `participante`
--
ALTER TABLE `participante`
  MODIFY `id_participante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `partida`
--
ALTER TABLE `partida`
  MODIFY `id_partida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `partida_pregunta`
--
ALTER TABLE `partida_pregunta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `pregunta`
--
ALTER TABLE `pregunta`
  MODIFY `id_pregunta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `respuesta`
--
ALTER TABLE `respuesta`
  MODIFY `id_respuesta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD CONSTRAINT `fk_admin_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `alternativa`
--
ALTER TABLE `alternativa`
  ADD CONSTRAINT `fk_alt_pregunta` FOREIGN KEY (`id_pregunta`) REFERENCES `pregunta` (`id_pregunta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `computadora`
--
ALTER TABLE `computadora`
  ADD CONSTRAINT `fk_pc_admin` FOREIGN KEY (`id_admin_supervisor`) REFERENCES `administrador` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `docente`
--
ALTER TABLE `docente`
  ADD CONSTRAINT `fk_docente_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `fk_estudiante_pc` FOREIGN KEY (`id_computadora`) REFERENCES `computadora` (`id_computadora`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_estudiante_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `participante`
--
ALTER TABLE `participante`
  ADD CONSTRAINT `fk_participante_estudiante` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_usuario`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_participante_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id_partida`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `partida`
--
ALTER TABLE `partida`
  ADD CONSTRAINT `fk_partida_docente` FOREIGN KEY (`id_docente`) REFERENCES `docente` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `partida_pregunta`
--
ALTER TABLE `partida_pregunta`
  ADD CONSTRAINT `fk_pp_partida` FOREIGN KEY (`id_partida`) REFERENCES `partida` (`id_partida`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pp_pregunta` FOREIGN KEY (`id_pregunta`) REFERENCES `pregunta` (`id_pregunta`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pregunta`
--
ALTER TABLE `pregunta`
  ADD CONSTRAINT `fk_pregunta_docente` FOREIGN KEY (`id_docente`) REFERENCES `docente` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuesta`
--
ALTER TABLE `respuesta`
  ADD CONSTRAINT `fk_resp_alt` FOREIGN KEY (`id_alternativa`) REFERENCES `alternativa` (`id_alternativa`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resp_participante` FOREIGN KEY (`id_participante`) REFERENCES `participante` (`id_participante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resp_pp` FOREIGN KEY (`id_partida_pregunta`) REFERENCES `partida_pregunta` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
