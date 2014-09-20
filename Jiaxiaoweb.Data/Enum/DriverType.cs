
using System.ComponentModel;
namespace Jiaxiaoweb.Common
{
    public enum DriverType
    {
        /// <summary>
        /// 所有
        /// </summary>
        All = -1,
        /// <summary>
        /// 小车-通用(C1,C2,C3,C4)
        /// </summary>
        [Description("小车-通用(C1,C2,C3,C4)")]
        Car = 1,

        /// <summary>
        /// 客车(A1,A3,B1)
        /// </summary>
        [Description("客车(A1,A3,B1)")]
        Coach = 2,

        [Description("货车(A2,B2)")]
        /// <summary>
        /// 货车(A2,B2)
        /// </summary>
        Truck = 3,

        /// <summary>
        /// 吊车,电瓶车(M)
        /// </summary>
        [Description("吊车,电瓶车(M)")]
        Crane = 4,

        /// <summary>
        /// 地方专用题
        /// </summary>
        [Description("地方专用题")]
        Local = 5,

        [Description("摩托车(D,E,F)")]
        /// <summary>
        /// 摩托车(D,E,F)
        /// </summary>
        Moto = 6
    }
}
