using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL
{
    public class TipObjaveBL : ITipObjaveBL
    {
        private readonly ITipObjaveDAL _ITipObjaveDAL;
        public TipObjaveBL(ITipObjaveDAL ITipObjaveDAL)
        {
            _ITipObjaveDAL = ITipObjaveDAL;
        }
        public List<TipObjave> getAllTipObjave()
        {
            return _ITipObjaveDAL.getAllTipObjave();
        }
    }
}
