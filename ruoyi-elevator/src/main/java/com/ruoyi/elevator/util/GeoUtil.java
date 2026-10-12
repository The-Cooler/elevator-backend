package com.ruoyi.elevator.util;

/**
 * 地理位置计算
 * 到场打卡要求维修员确实站在电梯附近，需要按坐标算两点间的实际距离。
 *
 * @author 董泽晟
 */
public class GeoUtil
{
    /** 地球平均半径（米） */
    private static final double EARTH_RADIUS = 6371000D;

    /**
     * 允许的打卡距离上限（米）
     * 电梯机房常在地下室或楼层中间，民用 GPS 在楼内漂移几十米是常态，
     * 取 300 米既能把"人在别的楼"挡在外，又不会误伤确实到了现场的人。
     */
    public static final int ALLOW_DISTANCE_METERS = 300;

    /**
     * 计算两个经纬度之间的距离，单位米
     * 用 Haversine 公式，短距离下精度足够
     *
     * @param lng1 第一个点的经度
     * @param lat1 第一个点的纬度
     * @param lng2 第二个点的经度
     * @param lat2 第二个点的纬度
     * @return 距离（米），四舍五入取整
     */
    public static int distance(double lng1, double lat1, double lng2, double lat2)
    {
        double radLat1 = Math.toRadians(lat1);
        double radLat2 = Math.toRadians(lat2);
        double deltaLat = radLat1 - radLat2;
        double deltaLng = Math.toRadians(lng1) - Math.toRadians(lng2);

        double h = Math.pow(Math.sin(deltaLat / 2), 2)
                + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(deltaLng / 2), 2);
        double distance = 2 * Math.asin(Math.sqrt(h)) * EARTH_RADIUS;

        return (int) Math.round(distance);
    }
}
