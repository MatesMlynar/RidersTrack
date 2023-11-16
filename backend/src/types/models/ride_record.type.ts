import Position from "../position.type";

export default interface RideRecord extends Document{
    _id: string;
    motorcycleId: string;
    date: Date;
    totalDistance: number;
    duration: number;
    maxSpeed: number;
    positionPoints: Array<Position>;
}