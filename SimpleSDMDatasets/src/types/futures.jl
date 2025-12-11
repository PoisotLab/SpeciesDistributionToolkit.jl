abstract type FutureScenario end
abstract type FutureModel end

# SSP scenarios
struct SSP119 <: FutureScenario end
struct SSP126 <: FutureScenario end
struct SSP245 <: FutureScenario end
struct SSP370 <: FutureScenario end
struct SSP434 <: FutureScenario end
struct SSP534 <: FutureScenario end
struct SSP585 <: FutureScenario end

# RCP scenarios
struct RCP26 <: FutureScenario end
struct RCP45 <: FutureScenario end
struct RCP60 <: FutureScenario end
struct RCP85 <: FutureScenario end

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

# CMIP5 GCMs + variants
struct ACCESS1_0 <: FutureModel end
struct BNU_ESM <: FutureModel end
struct CCSM4 <: FutureModel end
struct CESM1_BGC <: FutureModel end
struct CESM1_CAM5 <: FutureModel end
struct CMCC_CESM <: FutureModel end
struct CMCC_CMS <: FutureModel end
struct CMCC_CM <: FutureModel end
struct CNRM_CM5 <: FutureModel end
struct CSIRO_Mk3_6_0 <: FutureModel end
struct CSIRO_Mk3L_1_2 <: FutureModel end
struct CanESM2 <: FutureModel end
struct EC_EARTH <: FutureModel end
struct FGOALS_g2 <: FutureModel end
struct FIO_ESM <: FutureModel end
struct GFDL_CM3 <: FutureModel end
struct GFDL_ESM2G <: FutureModel end
struct GFDL_ESM2M <: FutureModel end
struct GISS_E2_H_CC <: FutureModel end
struct GISS_E2_H <: FutureModel end
struct GISS_E2_R_CC <: FutureModel end
struct GISS_E2_R <: FutureModel end
struct HadGEM2_AO <: FutureModel end
struct HadGEM2_CC <: FutureModel end
struct HadGEM2_ES <: FutureModel end
struct IPSL_CM5A_LR <: FutureModel end
struct IPSL_CM5A_MR <: FutureModel end
struct MIROC_ESM_CHEM <: FutureModel end
struct MIROC_ESM <: FutureModel end
struct MIROC5 <: FutureModel end
struct MPI_ESM_LR <: FutureModel end
struct MPI_ESM_MR <: FutureModel end
struct MRI_CGCM3 <: FutureModel end
struct MRI_ESM1 <: FutureModel end
struct NorESM1_ME <: FutureModel end

# CMIP6 Union types
CMIP6Scenario = Union{SSP119, SSP126, SSP245, SSP370, SSP434, SSP534, SSP585}
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

"""
    CMIP5Scenario

These scenarios are part of CMIP5. They can be `RCP26` to `RCP85` (with `RCPXX` the scenario).
"""
CMIP5Scenario = Union{RCP26, RCP45, RCP60, RCP85}
CMIP5Model = Union{
    ACCESS1_0,
    BNU_ESM,
    CCSM4,
    CESM1_BGC,
    CESM1_CAM5,
    CMCC_CESM,
    CMCC_CMS,
    CMCC_CM,
    CNRM_CM5,
    CSIRO_Mk3_6_0,
    CSIRO_Mk3L_1_2,
    CanESM2,
    EC_EARTH,
    FGOALS_g2,
    FIO_ESM,
    GFDL_CM3,
    GFDL_ESM2G,
    GFDL_ESM2M,
    GISS_E2_H_CC,
    GISS_E2_H,
    GISS_E2_R_CC,
    GISS_E2_R,
    HadGEM2_AO,
    HadGEM2_CC,
    HadGEM2_ES,
    IPSL_CM5A_LR,
    IPSL_CM5A_MR,
    MIROC_ESM_CHEM,
    MIROC_ESM,
    MIROC5,
    MPI_ESM_LR,
    MPI_ESM_MR,
    MRI_CGCM3,
    MRI_ESM1,
    NorESM1_ME,
}
