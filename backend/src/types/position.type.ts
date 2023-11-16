export default interface Position extends Document{
    longitude: number;
    latitude: number;
    altitude: number;
    speed: number;
    timestamp: Date;
}