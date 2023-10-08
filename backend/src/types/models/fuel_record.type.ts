export default interface FuelRecord extends Document {
    _id: string;
    user: string;
    motorcycleId: string;
    date: Date | null;
    distance: number | null;
    liters: number;
    consumption: number | null;
    totalPrice: number;
}