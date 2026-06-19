import Foundation

// Mock data source - dados centralizados para uso no app
struct DataSourceMock {
    static let orderTypes: [OrderType] = [
        OrderType(id: 1, name: "Restaurantes", image: "hamburguer"),
        OrderType(id: 2, name: "Mercado", image: "mercado"),
        OrderType(id: 3, name: "Farmácia", image: "farmacia"),
        OrderType(id: 4, name: "Pet", image: "petshop"),
        OrderType(id: 5, name: "Descontos", image: "descontos"),
        OrderType(id: 6, name: "Bebidas", image: "bebidas"),
        OrderType(id: 7, name: "Gourmet", image: "gourmet")
    ]
}
