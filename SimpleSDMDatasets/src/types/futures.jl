abstract type FutureScenario end
abstract type FutureModel end

# SSP scenarios
struct SSP126 <: FutureScenario end
struct SSP245 <: FutureScenario end
struct SSP370 <: FutureScenario end
struct SSP585 <: FutureScenario end

# CMIP6 GCMs + variants
struct ACCESS_CM2 <: FutureModel end
struct ACCESS_ESM1_5 <: FutureModel end
struct BCC_CSM2_MR <: FutureModel end
struct CanESM5 <: FutureModel end
struct CanESM5_CanOE <: FutureModel end
struct CMCC_ESM2 <: FutureModel end
struct CNRM_CM6_1 <: FutureModel end
struct CNRM_CM6_1_HR <: FutureModel end
struct CNRM_ESM2_1 <: FutureModel end
struct EC_Earth3_Veg <: FutureModel end
struct EC_Earth3_Veg_LR <: FutureModel end
struct FIO_ESM_2_0 <: FutureModel end
struct GFDL_ESM4 <: FutureModel end
struct GISS_E2_1_G <: FutureModel end
struct GISS_E2_1_H <: FutureModel end
struct HadGEM3_GC31_LL <: FutureModel end
struct INM_CM4_8 <: FutureModel end
struct INM_CM5_0 <: FutureModel end
struct IPSL_CM6A_LR <: FutureModel end
struct MIROC_ES2L <: FutureModel end
struct MIROC6 <: FutureModel end
struct MPI_ESM1_2_LR <: FutureModel end
struct MPI_ESM1_2_HR <: FutureModel end
struct MRI_ESM2_0 <: FutureModel end
struct UKESM1_0_LL <: FutureModel end

# CMIP6 Union types
CMIP6Scenario = Union{SSP126, SSP245, SSP370, SSP585}
CMIP6Model = Union{
    ACCESS_CM2,
    ACCESS_ESM1_5,
    BCC_CSM2_MR,
    CanESM5,
    CanESM5_CanOE,
    CMCC_ESM2,
    CNRM_CM6_1,
    CNRM_CM6_1_HR,
    CNRM_ESM2_1,
    EC_Earth3_Veg,
    EC_Earth3_Veg_LR,
    FIO_ESM_2_0,
    GFDL_ESM4,
    GISS_E2_1_G,
    GISS_E2_1_H,
    HadGEM3_GC31_LL,
    INM_CM4_8,
    INM_CM5_0,
    IPSL_CM6A_LR,
    MIROC_ES2L,
    MIROC6,
    MPI_ESM1_2_LR,
    MPI_ESM1_2_HR,
    MRI_ESM2_0,
    UKESM1_0_LL,
}