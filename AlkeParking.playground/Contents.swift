// IT Bootcamp - Swift
// Ejercicio Integrador 1
// por Joaquín Chávez
// 02/09/2022

import Foundation

// MARK: MODELO

// Modelo Estacionamiento.
struct Parking {
    var vehicles: Set<Vehicle> = []
    let capacity: Int = 20
    
    var status = (checkedOut: 0, earnings: 0)
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish:
    (Bool) -> Void) {
        
    // Insertar vehículo
        guard vehicles.count < capacity else {
            onFinish(false)
            return
        }
        guard vehicles.insert(vehicle).inserted else {
            onFinish(false)
            return
        }
        
        onFinish(true)
    }
    
    mutating func checkOutVehicle(plate: String, onSuccess: (Int) -> Void, onError: () -> Void) {
        // Chequear que existe el vehículo estacionado y guardarlo en selectedVehicle
        guard let selectedVehicle = self.vehicles.first(where: { $0.plate == plate }) else {
            onError()
            return
        }
        
        // Calcular tarifa según tiempo de estacionamiento y tarjeta de descuento.
        let fee = calculateFee(type: selectedVehicle.type, parkedTime: selectedVehicle.parkedTime, hasDisountCard: selectedVehicle.hasDiscountCard)
        
        // Remover vehículo del estacionamiento.
        self.vehicles.remove(selectedVehicle)
        // Actualizar recuento de check-outs del estacionamiento y ganancias.
        status.checkedOut += 1
        status.earnings += fee
        // Success
        onSuccess(fee)
    }
    
    // Función de cálculo de tarifa según tiempo y tarjeta de descuento.
    func calculateFee(type: VehicleType, parkedTime: Int, hasDisountCard: Bool) -> Int {
        
        // Todos los vehículos pagan la tarifa base, entre 1 min y 120 min.
        var fee = type.parkingRate
        var additionalTime = 0
        
        // Calculo de tarifa según fracciones de tiempo adicional
        if parkedTime > 120 {
            additionalTime = parkedTime - 120
            let additionalTimeFractions = (Double(additionalTime) / 15.0).rounded(.up)
            fee += Int(additionalTimeFractions) * 5
        }
        
        // Descuento con tarjeta
        if hasDisountCard {
            fee = Int(Double(fee) * 0.85)
        }
        
        return fee
        
    }
    
    // Función que lista patentes al interior del estacionamiento.
    func listVehicles() {
        print("Vehicle Plates List:")
        print("Occupation: \(vehicles.count) / \(self.capacity)")
        vehicles.enumerated().forEach { (index,vehicle) in
            print("\(index). \(vehicle.plate)")
        }
    }
    
    // Función que imprime estado actual de check-outs y ganancias.
    func printStatus() {
        print("\(status.checkedOut) vehicles have checked out and have earnings of $\(status.earnings)")
    }

}

// Tipos de vehículo aceptados en el estacionamiento.
enum VehicleType {
    case car, moto, miniBus, bus
    
    var parkingRate: Int {
        switch self {
        case .car:
            return 20
        case .moto:
            return 15
        case .miniBus:
            return 25
        case .bus:
            return 30
        }
    }
}

// Protocolo con requerimientos para usar el estacionamiento.
protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
}

// Modelo para vehículo.
struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var discountCard: String?
    var hasDiscountCard: Bool {
        discountCard != nil
    }
    
    var parkedTime: Int {
        let mins = Calendar.current.dateComponents([.minute], from:
        checkInTime, to: Date()).minute ?? 0
        return mins
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

// MARK: Mensajes en consola
// Función que imprime mensaje al intentar hacer check-in.
func checkInMessageIf(success: Bool) {
    if success {
        print("Welcome to AlkeParking!")
    } else {
        print("Sorry, the check-in failed.")
    }
    
}

// Mensajes de éxito o error al hacer check-out de un vehículo
let onSuccessMessage: (Int) -> (Void) = { fee in
    print("Your fee is $\(fee)")
}

let onErrorMessage = {
    print("Sorry, the check-out failed.")
}

// MARK: Testing
var alkeParking = Parking()

// Variable computada que entrega una hora de check-in al azar dentro de las úlimas 5 horas.
var randomCheckInTime: Date {
    let randomMinutesAgo = Int.random(in: -300...0)
    return Calendar.current.date(byAdding: .minute, value: randomMinutesAgo, to: Date()) ?? Date()
}

let vehicle1 = Vehicle(plate: "AA111AA", type:
VehicleType.car, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_001")

let vehicle2 = Vehicle(plate: "B222BBB", type:
VehicleType.moto, checkInTime: randomCheckInTime, discountCard: nil)

let vehicle3 = Vehicle(plate: "CC333CC", type:
VehicleType.miniBus, checkInTime: randomCheckInTime, discountCard:
nil)

let vehicle4 = Vehicle(plate: "DD444DD", type:
VehicleType.bus, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_002")

let vehicle5 = Vehicle(plate: "AA111BB", type:
VehicleType.car, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_003")

let vehicle6 = Vehicle(plate: "B222CCC", type:
  VehicleType.moto, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_004")

let vehicle7 = Vehicle(plate: "CC333DD", type:
VehicleType.miniBus, checkInTime: randomCheckInTime, discountCard:
nil)

let vehicle8 = Vehicle(plate: "DD444EE", type:
VehicleType.bus, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_005")

let vehicle9 = Vehicle(plate: "AA111CC", type:
VehicleType.car, checkInTime: randomCheckInTime, discountCard: nil)

let vehicle10 = Vehicle(plate: "B222DDD", type:
VehicleType.moto, checkInTime: randomCheckInTime, discountCard: nil)

let vehicle11 = Vehicle(plate: "CC333EE", type:
VehicleType.miniBus, checkInTime: randomCheckInTime, discountCard:
nil)

let vehicle12 = Vehicle(plate: "DD444GG", type:
VehicleType.bus, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_006")

let vehicle13 = Vehicle(plate: "AA111DD", type:
VehicleType.car, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_007")

let vehicle14 = Vehicle(plate: "B222EEE", type:
 VehicleType.moto, checkInTime: randomCheckInTime, discountCard: nil)

let vehicle15 = Vehicle(plate: "CC333FF", type:
VehicleType.miniBus, checkInTime: randomCheckInTime, discountCard:
nil)

let vehicle16 = Vehicle(plate: "DD344GG", type:
VehicleType.bus, checkInTime: randomCheckInTime, discountCard:
nil)

let vehicle17 = Vehicle(plate: "CA311EE", type:
VehicleType.car, checkInTime: randomCheckInTime, discountCard:
"DISCOUNT_CARD_008")

let vehicle18 = Vehicle(plate: "C232GFF", type:
VehicleType.moto, checkInTime: Date(), discountCard:
"DISCOUNT_CARD_009")

let vehicle19 = Vehicle(plate: "CC333GG", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

let vehicle20 = Vehicle(plate: "CD344HH", type:
VehicleType.bus, checkInTime: Date(), discountCard:
nil)

let vehicle21 = Vehicle(plate: "CA311FF", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

// Vehículo con patente ya existente.
let repeatedPlateVehicle = Vehicle(plate: "C232GFF", type:
VehicleType.miniBus, checkInTime: Date(), discountCard:
nil)

// Arreglo con 20 vehículos y el último con patente repetida para testear check-in.
let vehiclesArray = [vehicle1, vehicle2, vehicle3, vehicle4, vehicle5,
                     vehicle6, vehicle7, vehicle8, vehicle9, vehicle10,
                     vehicle11, vehicle12, vehicle13, vehicle14, vehicle15,
                     vehicle16, vehicle17, vehicle18, vehicle19, repeatedPlateVehicle]

// Proceso de check-in para el arreglo anterior.
vehiclesArray.forEach { vehicle in
    alkeParking.checkInVehicle(vehicle) { checkInMessageIf(success: $0) }
}

// Rellenar el espacio disponible dejado por el vehículo con patente repetida rechazado.
alkeParking.checkInVehicle(vehicle20) { checkInMessageIf(success: $0) }
// Testear rechazo de vehículo si el estacionamiento está lleno.
alkeParking.checkInVehicle(vehicle21) { checkInMessageIf(success: $0) }

// Imprimir estado actual del estacionamiento.
alkeParking.printStatus()

// Hacer checkout de vehículos
alkeParking.checkOutVehicle(plate: "C232GFF", onSuccess:{ onSuccessMessage($0) }, onError: { onErrorMessage() })
// Verificar estado actualizado
alkeParking.printStatus()

alkeParking.checkOutVehicle(plate: "CC333GG", onSuccess:{ onSuccessMessage($0) }, onError: { onErrorMessage() })
// Verificar estado actualizado
alkeParking.printStatus()

alkeParking.checkOutVehicle(plate: "B222BBB", onSuccess:{ onSuccessMessage($0) }, onError: { onErrorMessage() })
// Verificar estado actualizado
alkeParking.printStatus()

alkeParking.checkOutVehicle(plate: "B222CCC", onSuccess:{ onSuccessMessage($0) }, onError: { onErrorMessage() })
// Verificar estado actualizado
alkeParking.printStatus()

// Prueba de check-out con vehículo no existente
alkeParking.checkOutVehicle(plate: "AAAAAAA", onSuccess:{ onSuccessMessage($0) }, onError: { onErrorMessage() })
// Verificar estado actualizado
alkeParking.printStatus()

// Imprimir lista de patentes al interior del estacionamiento.
alkeParking.listVehicles()


