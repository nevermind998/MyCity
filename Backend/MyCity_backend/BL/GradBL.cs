using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class GradBL : IGradBL
    {
        private readonly IGradDAL _IGradDAL;
        private readonly List<Grad> gradovi;

        public GradBL(IGradDAL IGradDAL)
        {
           _IGradDAL = IGradDAL;
            gradovi = _IGradDAL.getAllGradove();
        }
        public List<Grad> getAllGradove()
        {
            return _IGradDAL.getAllGradove();
        }

        public Grad getGradByIdGrada(long idGrada)
        {
            return gradovi.SingleOrDefault(g => g.id == idGrada);
        }

        public List<Grad> getGradoveByNizIdGradova(List<long> nizGradova)
        {
            List<Grad> listaGradova = new List<Grad>();
            foreach (var id in nizGradova)
            {
                var grad = this.getGradByIdGrada(id);
                if (grad != null)
                {
                    listaGradova.Add(grad);
                }

            }
            return listaGradova;
        }
    }
}
