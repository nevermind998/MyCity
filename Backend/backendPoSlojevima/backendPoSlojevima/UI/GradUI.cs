using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.UI.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.UI
{
    public class GradUI : IGradUI
    {
        private readonly IGradBL _IGradBL;
     
        public GradUI (IGradBL IGradBL)
        {
            _IGradBL = IGradBL;
        }

        public List<Grad> getAllGradove()
        {
            return _IGradBL.getAllGradove();
        }

        public Grad getGradByIdGrada(long idGrada)
        {
            return _IGradBL.getGradByIdGrada(idGrada);
        }

        public List<Grad> getGradoveByNizIdGradova(List<long> nizGradova)
        {
            return _IGradBL.getGradoveByNizIdGradova(nizGradova);
        }
    }
}
