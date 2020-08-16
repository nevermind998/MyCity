using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.UI
{
    public class TipObjaveUI : ITipObjaveUI
    {
        private readonly ITipObjaveBL _ITipObjaveBL;

        public TipObjaveUI(ITipObjaveBL ITipObjaveBL)
        {
            _ITipObjaveBL = ITipObjaveBL;
        }
        public List<TipObjave> getAllTipObjave()
        {
            return _ITipObjaveBL.getAllTipObjave();
        }
    }
}
