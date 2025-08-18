import Data.Time.Clock
import Data.List
import System.IO
import Control.Exception
import Control.Concurrent (threadDelay)
import Data.Maybe (mapMaybe)
import Text.Read (readMaybe)

-- Definición del tipo de datos para representar la información de un vehículo
data Prestamo = Prestamo {
    iDLibro :: String,
    prestado :: UTCTime,
    devuelto :: Maybe UTCTime  -- Usamos Maybe para representar que el vehículo aún está en el parqueadero o ya salió
} deriving (Show, Read)

-- Función para registrar la entrada de un vehículo al parqueadero
registrarPrestamo :: String -> UTCTime -> [Prestamo] -> [Prestamo]
registrarPrestamo iDLibroPrestamo tiempo biblioteca =
    Prestamo iDLibroPrestamo tiempo Nothing : biblioteca

-- Función para registrar la salida de un vehículo del parqueadero
registrarDevolucion :: String -> UTCTime -> [Prestamo] -> [Prestamo]
registrarDevolucion iDLibroPrestamo tiempo biblioteca =
    map (\p -> if iDLibroPrestamo == iDLibro p then p { devuelto = Just tiempo } else p) biblioteca

-- Función para buscar un vehículo por su placa en el parqueadero
buscarLibro :: String -> [Prestamo] -> Maybe Prestamo
buscarLibro iDLibroPrestamo biblioteca =
    find (\p -> iDLibroPrestamo == iDLibro p && isNothing (devuelto p)) biblioteca
    where
        isNothing Nothing = True
        isNothing _       = False

-- Función para calcular el tiempo que un vehículo permaneció en el parqueadero
tiempoEnBiblioteca :: Prestamo -> UTCTime -> NominalDiffTime
tiempoEnBiblioteca libro tiempoActual =
    case devuelto libro of
        Just tiempoDevuelto -> diffUTCTime tiempoDevuelto (prestado libro)
        Nothing           -> diffUTCTime tiempoActual (prestado libro)

-- Función para guardar la información de los vehículos en un archivo de texto
guardarBiblioteca :: [Prestamo] -> IO ()
guardarBiblioteca biblioteca = do
    resultado <- reintentar 5 (writeFile "biblioteca.txt" (unlines (map show biblioteca)))
    case resultado of
        Left ex -> putStrLn $ "Error guardando la biblioteca: " ++ show ex
        Right _ -> putStrLn "Biblioteca guardada en el archivo biblioteca.txt."

-- Función para reintentar una operación en caso de error
reintentar :: Int -> IO a -> IO (Either IOException a)
reintentar 0 accion = catch (accion >>= return . Right) (\(ex :: IOException) -> return (Left ex))
reintentar n accion = do
    resultado <- catch (accion >>= return . Right) (\(ex :: IOException) -> return (Left ex))
    case resultado of
        Left ex -> do
            threadDelay 1000000  -- Esperar 1 segundo antes de reintentar
            reintentar (n - 1) accion
        Right val -> return (Right val)

-- Función para cargar la información de los vehículos desde un archivo de texto
cargarBiblioteca :: IO [Prestamo]
cargarBiblioteca = do
    resultado <- try (readFile "biblioteca.txt") :: IO (Either IOException String)
    case resultado of
        Left ex -> do
            putStrLn $ "Error cargando la biblioteca: " ++ show ex
            return []
        Right contenido -> do
            _ <- evaluate (length contenido)
            let lineas = lines contenido
            return (map leerLibro lineas)
    where
        leerLibro linea = read linea :: Prestamo

-- Función para mostrar la información de un vehículo como cadena de texto
mostrarLibro :: Prestamo -> String
mostrarLibro libro =
    iDLibro libro ++ "," ++ show (prestado libro) ++ "," ++ show (devuelto libro)

-- Función para cargar la información de los vehículos desde un archivo de texto
leerBiblioteca :: IO [Prestamo]
leerBiblioteca = do
    contenido <- readFile "biblioteca.txt"
    _ <- evaluate (length contenido)
    let lineas = lines contenido
    return (mapMaybe parsearLibro lineas)
    where
        parsearLibro :: String -> Maybe Prestamo
        parsearLibro linea = readMaybe linea
       


-- Función para el ciclo principal del programa
cicloPrincipal :: [Prestamo] -> IO ()
cicloPrincipal biblioteca = do
    putStrLn "\nSeleccione una opción:"
    putStrLn "1. Registrar Prestamo (Check Out)"
    putStrLn "2. Registrar Devolcion (Check In)"
    putStrLn "3. Buscar libro por ID"
    putStrLn "4. Listar los Libros Prestados"
    putStrLn "5. Salir"

    opcion <- getLine
    case opcion of
        "1" -> do
            putStrLn "Ingrese la ID del libro:"
            iDLibroPrestamo <- getLine
            tiempoActual <- getCurrentTime
            let bibliotecaActualizado = registrarPrestamo iDLibroPrestamo tiempoActual biblioteca
            putStrLn $ "Libro con ID:" ++ iDLibroPrestamo ++ " Prestado Correctamente."
            guardarBiblioteca bibliotecaActualizado
            cicloPrincipal bibliotecaActualizado

        "2" -> do
            putStrLn "Ingrese el ID del Libro a Devolver:"
            iDLibroPrestamo <- getLine
            tiempoActual <- getCurrentTime
            let bibliotecaActualizado = registrarDevolucion iDLibroPrestamo tiempoActual biblioteca
            putStrLn $ "Libro con ID: " ++ iDLibroPrestamo ++ " Devuelto Correctamente a la Biblioteca"
            guardarBiblioteca bibliotecaActualizado
            cicloPrincipal bibliotecaActualizado

        "3" -> do
            putStrLn "Ingrese el ID del libro a buscar: "
            iDLibroPrestado <- getLine
            case buscarLibro iDLibroPrestado biblioteca of
                Just libro -> do
                    tiempoActual <- getCurrentTime
                    let tiempoTotal = tiempoEnBiblioteca libro tiempoActual
                    putStrLn $ "El Libro con ID: " ++ iDLibroPrestado ++ " se encuentra Prestado"
                    putStrLn $ "Tiempo en prestamo: " ++ show tiempoTotal ++ " segundos."
                Nothing -> putStrLn "Libro no encontrado en la biblioteca."
            cicloPrincipal biblioteca
        "4" -> do
            putStrLn "Mostrando Lista de Libros prestados actualmente."
            -- Leer el parqueadero actualizado
            bibliotecaActualizado <- leerBiblioteca
            mapM_ (\p -> putStrLn $ "ID: " ++ iDLibro p ++ ", Hora de Prestamo " ++ show (prestado p) ++ ", Hora de Devolucion " ++ show (devuelto p)) bibliotecaActualizado
            cicloPrincipal bibliotecaActualizado  -- Mantenemos el parqueadero actualizado




        "5" -> putStrLn "¡Hasta luego!"

        _ -> do
            putStrLn "Opción no válida. Por favor, seleccione una opción válida."
            cicloPrincipal biblioteca

-- Función principal del programa
main :: IO ()
main = do
    -- Cargar el parqueadero desde el archivo de texto
    biblioteca <- cargarBiblioteca
    putStrLn "¡Bienvenido al Sistema de prestamo de libros!"

    -- Ciclo principal del programa
    cicloPrincipal biblioteca

